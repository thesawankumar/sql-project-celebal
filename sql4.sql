create DATABASE College;
use College;
DROP DATABASE College;
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    gpa DECIMAL(3, 2),
    branch VARCHAR(100)
);

CREATE TABLE subjects (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(100),
    available_seats INT
);

CREATE TABLE preferences (
    preference_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    subject_id INT,
    preference_order INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

CREATE TABLE allocations (
    allocation_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    subject_id INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

-- Insert students
INSERT INTO students (student_id, student_name, gpa, branch) VALUES
(1, 'Mohit', 3.8, 'Computer Science'),
(2, 'Sara', 3.9, 'Mechanical Engineering'),
(3, 'John', 3.7, 'Electrical Engineering');
-- Insert subjects
INSERT INTO subjects (subject_id, subject_name, available_seats) VALUES
(1, 'Mathematics', 60),
(2, 'Physics', 60),
(3, 'Chemistry', 60),
(4, 'Biology', 60),
(5, 'Computer Science', 60);

-- Insert preferences
INSERT INTO preferences (student_id, subject_id, preference_order) VALUES
(1, 1, 1), -- Mohit's first choice is Mathematics
(1, 2, 2), -- Mohit's second choice is Physics
(1, 3, 3), -- Mohit's third choice is Chemistry
(1, 4, 4), -- Mohit's fourth choice is Biology
(1, 5, 5), -- Mohit's fifth choice is Computer Science

(2, 2, 1), -- Sara's first choice is Physics
(2, 1, 2), -- Sara's second choice is Mathematics
(2, 3, 3), -- Sara's third choice is Chemistry
(2, 4, 4), -- Sara's fourth choice is Biology
(2, 5, 5), -- Sara's fifth choice is Computer Science

(3, 3, 1), -- John's first choice is Chemistry
(3, 4, 2), -- John's second choice is Biology
(3, 2, 3), -- John's third choice is Physics
(3, 1, 4), -- John's fourth choice is Mathematics
(3, 5, 5); -- John's fifth choice is Computer Science


DELIMITER //

CREATE PROCEDURE allocate_subjects()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE student INT;
    DECLARE gpa DECIMAL(3, 2);
    DECLARE pref_id INT;
    DECLARE subj_id INT;
    DECLARE remaining_seats INT;

    DECLARE student_cursor CURSOR FOR 
        SELECT student_id, gpa FROM students ORDER BY gpa DESC;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN student_cursor;

    student_loop: LOOP
        FETCH student_cursor INTO student, gpa;
        IF done THEN
            LEAVE student_loop;
        END IF;

        SET pref_id = 1;

        preference_loop: LOOP
            SELECT subject_id INTO subj_id 
            FROM preferences 
            WHERE student_id = student AND preference_order = pref_id;
            
            IF subj_id IS NULL THEN
                LEAVE preference_loop;
            END IF;

            SELECT available_seats INTO remaining_seats 
            FROM subjects 
            WHERE subject_id = subj_id;
            
            IF remaining_seats > 0 THEN
                INSERT INTO allocations (student_id, subject_id) VALUES (student, subj_id);
                UPDATE subjects 
                SET available_seats = available_seats - 1 
                WHERE subject_id = subj_id;
                LEAVE preference_loop;
            END IF;

            SET pref_id = pref_id + 1;
        END LOOP preference_loop;
    END LOOP student_loop;

    CLOSE student_cursor;
END //

DELIMITER ;
CALL allocate_subjects();


SELECT s.student_id, s.student_name, s.gpa, s.branch, sub.subject_name
FROM allocations a
JOIN students s ON a.student_id = s.student_id
JOIN subjects sub ON a.subject_id = sub.subject_id;

SELECT s.student_id, s.student_name, s.gpa, s.branch, sub.subject_name
FROM allocations a
JOIN students s ON a.student_id = s.student_id
JOIN subjects sub ON a.subject_id = sub.subject_id;
