# DBMS-Project-
Databases Management System Project 

This is a hospital management web application for MNHS. It allows managing patients, appointments, medications, and staff workload. The app is built with Python (Flask) for the backend and HTML/CSS/JS for the frontend.


Setup and Installation
1.	Clone the repository:
git clone https://github.com/hash-gdel/DBMS-Project.git                                                                                                                                   
cd MNHS-APP
2.	Create a virtual environment:                                                                                                                                                          
python -m venv venv                                                                                                                                                                        
source venv/bin/activate (Linux / macOS)                                                                                                                                                            
venv\Scripts\activate (Windows)

4.	Install dependencies:
   
pip install flask mysql-connector-python python-dotenv

6.	Set up environment variables by creating a .env file in the root with:
   
      MYSQL_HOST=localhost
      
      MYSQL_PORT=3306
      
      MYSQL_DB=lab3
      
      MYSQL_USER=mnhs_user
      
      MYSQL_PASSWORD=MNHS123

8.	Prepare the database. Make sure MySQL is running, then run:

      CREATE DATABASE IF NOT EXISTS lab3;
      
      CREATE USER 'mnhs_user'@'localhost' IDENTIFIED BY 'MNHS123’';
      
      GRANT ALL PRIVILEGES ON lab3.* TO 'mnhs_user'@'localhost';
      
      FLUSH PRIVILEGES;


Running the App:

      python3  app.py



