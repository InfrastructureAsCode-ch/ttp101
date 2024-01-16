import yaml
from flask import Flask, render_template, request, Response, url_for, jsonify
from ttp import ttp

app = Flask(__name__, static_url_path="/static")
config = {"name": "TTP", "data": "RAW", "rendered": "JSON"}
app.json.sort_keys = False
app.config.update(
    TITLE="TTP",
    SUBTITLE="Playground for TTP templates",
    GITHUB="https://github.com/infrastructureAsCode-ch/ttp101/",
    
)

@app.route("/")
def index():
    return render_template("index.html", **config)


@app.route("/examples")
def examples():
    try:
        with open("examples.yaml", "r") as f:
            data = yaml.safe_load(f)
        resp = jsonify(data)
    except Exception as e:
        resp = jsonify({"error": f"Error {type(e).__name__}", "msg": str(e)})
        resp.status_code = 400
    finally:
        return resp


@app.route("/rend", methods=["POST"])
def rend():
    data = request.get_json()
    if not isinstance(data, dict):
        resp = jsonify({"error": "Invalid JSON"})
        resp.status_code = 400
        return resp
    ttp_template = data.get("template", "")
    raw_data = data.get("data")

    try:
        parser = ttp(data=raw_data, template=ttp_template)
        parser.parse()
        output = parser.result(format="json")

        resp = jsonify({"result": output})
    except Exception as e:
        resp = jsonify({"error": f"Error {type(e).__name__}", "msg": str(e)})
        resp.status_code = 400
    finally:
        return resp


if __name__ == "__main__":
    app.run(debug=True)
