from ttp import ttp

ttp_template = (
    "{{time}} {{time_zone}} {{week_day}} {{month}} ",
    "{{day|isdigit}} {{year|isdigit}}",
)

raw_data = "17:00:00.0 CET Mon Okt 26 2021"

parser = ttp(data=raw_data, template=ttp_template)
parser.parse()
output = parser.result(format="json")
print(output[0])
