from flask import Flask, render_template, jsonify
from hospital_app import list_patients_ordered_by_last_name, low_stock, staff_share, schedule_appointment
import random
from datetime import datetime, timedelta

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

@app.route('/api/next_visits')
def api_next_visits():
    try:
        # This should be implemented in hospital_app.py
        # For now, return dummy data
        data = [
            {'IID': 1, 'FullName': 'Sara El Amrani', 'NextAppointment': '2025-03-15', 'Department': 'Cardiology', 'Hospital': 'Benguerir Central Hospital'},
            {'IID': 2, 'FullName': 'Youssef Benali', 'NextAppointment': '2025-03-16', 'Department': 'Cardiology', 'Hospital': 'Benguerir Central Hospital'},
            {'IID': 3, 'FullName': 'Hajar Berrada', 'NextAppointment': '2025-03-17', 'Department': 'Pediatrics', 'Hospital': 'Benguerir Central Hospital'},
        ]
        return jsonify(data)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/upcoming_appointments')
def api_upcoming_appointments():
    try:
        # This should be implemented in hospital_app.py
        # For now, return realistic data
        data = [
            {'Hospital': 'Benguerir Central Hospital', 'Date': '2025-03-15', 'ScheduledCount': 8},
            {'Hospital': 'Casablanca University Hospital', 'Date': '2025-03-16', 'ScheduledCount': 12},
            {'Hospital': 'Rabat Clinical Center', 'Date': '2025-03-17', 'ScheduledCount': 6},
            {'Hospital': 'Marrakech Regional Hospital', 'Date': '2025-03-18', 'ScheduledCount': 9},
            {'Hospital': 'Agadir City Hospital', 'Date': '2025-03-19', 'ScheduledCount': 5},
        ]
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
        data = low_stock()
        return jsonify(data)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/staff_share')
def api_staff_share():
    try:
        data = staff_share()
        return jsonify(data)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)