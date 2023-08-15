-- Create tables
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birthdate DATE,
    gender VARCHAR(10)
);

CREATE TABLE teachers (
    teacher_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(100)
);

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100),
    head_of_department INT,
    location VARCHAR(100)
);

CREATE TABLE classrooms (
    classroom_id INT PRIMARY KEY,
    department_id INT,
    room_number VARCHAR(20),
    capacity INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    credits INT
);

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE assignments (
    assignment_id INT PRIMARY KEY,
    course_id INT,
    assignment_name VARCHAR(100),
    max_score INT,
    assignment_date DATE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE grades (
    grade_id INT PRIMARY KEY,
    enrollment_id INT,
    assignment_id INT,
    score INT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id),
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id)
);

CREATE TABLE class_schedules (
    schedule_id INT PRIMARY KEY,
    classroom_id INT,
    course_id INT,
    teacher_id INT,
    day_of_week VARCHAR(10),
    start_time TIME,
    end_time TIME,
    FOREIGN KEY (classroom_id) REFERENCES classrooms(classroom_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

-- Insert data
INSERT INTO students (student_id, first_name, last_name, birthdate, gender)
VALUES
    (1, 'John', 'Doe', '2000-05-15', 'Male'),
    (2, 'Jane', 'Smith', '2001-02-10', 'Female'),
    (3, 'Michael', 'Johnson', '1999-08-22', 'Male');

INSERT INTO teachers (teacher_id, first_name, last_name, specialization)
VALUES
    (1, 'Sarah', 'Williams', 'Mathematics'),
    (2, 'David', 'Smith', 'Science'),
    (3, 'Emily', 'Johnson', 'History');

INSERT INTO departments (department_id, department_name, head_of_department, location)
VALUES
    (1, 'Mathematics', 1, 'Building A, Floor 2'),
    (2, 'Science', 2, 'Building B, Floor 1'),
    (3, 'History', 3, 'Building C, Floor 3');

INSERT INTO classrooms (classroom_id, department_id, room_number, capacity)
VALUES
    (1, 1, 'A201', 30),
    (2, 1, 'A202', 25),
    (3, 2, 'B101', 40),
    (4, 3, 'C301', 20);

INSERT INTO courses (course_id, course_name, credits)
VALUES
    (101, 'Mathematics', 3),
    (102, 'Science', 4),
    (103, 'History', 2);

INSERT INTO enrollments (enrollment_id, student_id, course_id, enrollment_date)
VALUES
    (1, 1, 101, '2023-01-15'),
    (2, 1, 102, '2023-01-15'),
    (3, 2, 102, '2023-02-01'),
    (4, 3, 101, '2023-02-10'),
    (5, 3, 103, '2023-02-10');

INSERT INTO assignments (assignment_id, course_id, assignment_name, max_score, assignment_date)
VALUES
    (1, 101, 'Math Quiz 1', 20, '2023-03-01'),
    (2, 101, 'Math Quiz 2', 25, '2023-03-15'),
    (3, 102, 'Science Lab Report', 30, '2023-03-10'),
    (4, 103, 'History Essay', 15, '2023-03-05');

INSERT INTO grades (grade_id, enrollment_id, assignment_id, score)
VALUES
    (1, 1, 1, 18),
    (2, 1, 2, 23),
    (3, 2, 3, 28),
    (4, 3, 1, 16),
    (5, 3, 4, 14);

INSERT INTO class_schedules (schedule_id, classroom_id, course_id, teacher_id, day_of_week, start_time, end_time)
VALUES
    (1, 1, 101, 1, 'Monday', '09:00:00', '10:30:00'),
    (2, 2, 101, 1, 'Wednesday', '09:00:00', '10:30:00'),
    (3, 3, 102, 2, 'Tuesday', '10:00:00', '11:30:00'),
    (4, 4, 103, 3, 'Thursday', '13:00:00', '14:30:00');

-- Complex queries
-- Query 1: Get the full name of students and the courses they are enrolled in
SELECT s.first_name, s.last_name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Query 2: Get the average score for each assignment in a specific course
SELECT c.course_name, a.assignment_name, AVG(g.score) AS avg_score
FROM courses c
JOIN assignments a ON c.course_id = a.course_id
LEFT JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY c.course_name, a.assignment_name;

-- Query 3: Get the top-performing student (highest average score) for each course
SELECT c.course_name, s.first_name, s.last_name, AVG(g.score) AS avg_score
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN students s ON e.student_id = s.student_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_name, s.first_name, s.last_name
HAVING AVG(g.score) IS NOT NULL
ORDER BY c.course_name, avg_score DESC;

-- Query 4: Get the number of assignments without any grades in each course
SELECT c.course_name, COUNT(a.assignment_id) AS ungraded_assignments
FROM courses c
JOIN assignments a ON c.course_id = a.course_id
LEFT JOIN grades g
