import os
import re
import datetime
import jinja2

time_logs = {}

path_root     = os.environ["ROOT_DIR"]
path_script   = os.path.abspath(os.path.dirname(__file__))
path_results  = os.environ["RESULTS_DIR"]
path_time_log = os.environ["TIME_LOG"]

# Create the verifications results directory
if not os.path.exists(path_results):
  os.makedirs(path_results)

# Iterate over entries in the time logs
time_log_entry_regex = re.compile(r"([^ ]*)\s(start|end)\n([^\n]*)\n")
with open(path_time_log, 'r') as time_log_file:
  for entry in time_log_entry_regex.finditer(time_log_file.read()):
    step      = entry.group(1)
    start_end = entry.group(2)
    time_str  = entry.group(3)
    # If testcase path, reduce to testcase name
    if ('/' in step):
      step = os.path.basename(os.path.normpath(step))
    timestamp = datetime.datetime.strptime(time_str,"%Y/%m/%d-%H:%M:%S")
    if start_end == "start":
      time_logs[step] = {}
      time_logs[step]["start_string"]    = time_str
      time_logs[step]["start_timestamp"] = timestamp
    else:
      time_logs[step]["end_string"]    = time_str
      time_logs[step]["end_timestamp"] = timestamp
      time_logs[step]["duration"]      = (time_logs[step]["end_timestamp"]
                                       -  time_logs[step]["start_timestamp"])

# Render the report template
env = jinja2.Environment(loader=jinja2.FileSystemLoader(path_script))
template = env.get_template("maketime_report.html.j2")
path_maketime_report = os.path.join(path_results, "report_maketime.html")
with open(path_maketime_report, "w") as maketime_report_file:
  maketime_report_file.write(template.render(time_logs=time_logs))
