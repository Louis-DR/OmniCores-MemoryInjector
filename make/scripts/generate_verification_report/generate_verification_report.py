import os
import shutil
import re
import jinja2
import xml.etree.ElementTree as ET
import datetime

results = {}

path_root          = os.environ["ROOT_DIR"]
path_testcases     = os.environ["TESTCASES_DIR"]
path_results       = os.environ["RESULTS_DIR"]
path_results_verif = os.path.join(path_results, "verification")

# Create the verifications results directory
if not os.path.exists(path_results_verif):
  os.makedirs(path_results_verif)

# Iterate over testcase directories
for testcase in os.listdir(path_testcases):
  path_testcase = os.path.join(path_testcases, testcase)

  # Copy the waveform
  path_source_waveform = os.path.join(path_testcase,"waveform.vcd")
  path_result_waveform = os.path.join(path_results_verif, f"{testcase}.vcd")
  shutil.copyfile(path_source_waveform, path_result_waveform)

  # Copy the trace log without ANSII color codes
  path_source_logfile = os.path.join(path_testcase,"trace.log")
  path_result_logfile = os.path.join(path_results_verif, f"{testcase}.log")
  ansii_codes_regex = re.compile(r"\x1b\[[0-9;]*m")
  with open(path_source_logfile, 'r') as source_logfile:
    with open(path_result_logfile, 'w') as result_logfile:
      for line in source_logfile:
        result_logfile.write(ansii_codes_regex.sub("", line))

  # Read the CocoTB results file
  path_testcase_xml = os.path.join(path_testcase, "results.xml")
  testcase_xml_tree = ET.parse(path_testcase_xml)
  testcase_xml_obj = testcase_xml_tree.getroot()[0][1]
  simulation_time = round(float(testcase_xml_obj.attrib["sim_time_ns"]), 2)
  execution_time = float(testcase_xml_obj.attrib["time"])
  failure = len(list(testcase_xml_obj)) > 0 and testcase_xml_obj[0].tag == "failure"
  run_date = datetime.datetime.utcfromtimestamp(os.path.getmtime(path_source_logfile))

  # Register testcase with its results
  results[testcase] = {
    "pass": not failure,
    "simulation_time": simulation_time,
    "execution_time": execution_time,
    "trace_file": os.path.basename(path_result_logfile),
    "waveform_file": os.path.basename(path_result_waveform),
    "date": run_date.strftime('%Y/%m/%d-%H:%M:%S')
  }

# Render the report template
env = jinja2.Environment(loader=jinja2.FileSystemLoader(path_script))
template = env.get_template("verification_report.html.j2")
path_verification_report = os.path.join(path_results, "report_verification.html")
with open(path_verification_report, "w") as verification_report_file:
  verification_report_file.write(template.render(testcases=results))
