CREATE TABLE SubjectAllotments (
    StudentID INT,
    SubjectID INT,
    PreferenceDate DATE,
    IsActive BOOLEAN,
    PRIMARY KEY (StudentID, SubjectID, PreferenceDate)
);
INSERT INTO SubjectAllotments (StudentID, SubjectID, PreferenceDate, IsActive)
VALUES (1, 101, '2023-09-01', TRUE);
UPDATE SubjectAllotments
SET IsActive = FALSE
WHERE StudentID = 1 AND IsActive = TRUE;
INSERT INTO SubjectAllotments (StudentID, SubjectID, PreferenceDate, IsActive)
VALUES (1, 102, '2023-09-15', TRUE);
SELECT * FROM SubjectAllotments
WHERE StudentID = 1
ORDER BY PreferenceDate;
