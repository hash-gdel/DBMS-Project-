from flask import Flask, render_template, jsonify
from hospital_app import list_patients_ordered_by_last_name, low_stock, staff_share, schedule_appointment
import random

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/api/patients')
def api_patients():
    try:
        data = list_patients_ordered_by_last_name()
        return jsonify(data)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/schedule_appointment')
def api_schedule_appointment():
    try:
        dummy_caid = random.randint(10000, 99999)
        schedule_appointment(
            caid=dummy_caid,
            iid=1,
            staff_id=501,
            dep_id=10,
            date_str='2025-12-01',
            time_str='09:00:00',
            reason='Routine Checkup'
        )
        return jsonify({"message": "Dummy appointment scheduled", "CAID": dummy_caid})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/low_stock')
def api_low_stock():
    try:
        data = low_stock()  # Make sure this function returns a list, not just prints
        return jsonify(data)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/staff_share')
def api_staff_share():
    try:
        data = staff_share()  # Make sure this function returns a list
        return jsonify(data)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)



