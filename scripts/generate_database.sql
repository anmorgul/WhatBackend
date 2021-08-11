DROP DATABASE IF EXISTS `Soft`;

CREATE DATABASE IF NOT EXISTS `Soft`
CHARACTER SET UTF8MB4
COLLATE UTF8MB4_0900_AI_CI;

USE `Soft`;

-- Table `Attachments`

DROP TABLE IF EXISTS `Attachments`;

CREATE TABLE `Attachments` (
    `ID`                    BIGINT UNSIGNED    NOT NULL     AUTO_INCREMENT,
    `CreatedOn`             DATETIME           NOT NULL,
    `CreatedByAccountID`    BIGINT UNSIGNED    NOT NULL,
    `ContainerName`         VARCHAR(36)        NOT NULL     COMMENT 'GUID length is 36 characters',
    `FileName`              VARCHAR(100)       NOT NULL,

    CONSTRAINT    `PK_Attachment`                  PRIMARY KEY (`ID`),
    CONSTRAINT    `UQ_ContainerNameAttachments`    UNIQUE (`ContainerName`)
);

-- Table `Accounts`

DROP TABLE IF EXISTS `Accounts`;

CREATE TABLE `Accounts` (
    `ID`                     BIGINT UNSIGNED     NOT NULL         AUTO_INCREMENT,
    `Role`                   TINYINT UNSIGNED    DEFAULT NULL     COMMENT 'Roles:\n 0 - NotAssigned,\n 1 - Student,\n 2 - Mentor,\n 4 - Admin,\n 8 - Secretary',
    `FirstName`              VARCHAR(30)         NOT NULL,
    `LastName`               VARCHAR(30)         NOT NULL,
    `Email`                  VARCHAR(50)         NOT NULL,
    `PasswordHash`           VARBINARY(256)      NOT NULL         COMMENT 'SHA256 produces 256-bit hash value',
    `Salt`                   VARBINARY(128)      NOT NULL         COMMENT 'Standart salt length is 128 bits',
    `IsActive`               BIT                 DEFAULT 1,
    `ForgotPasswordToken`    VARCHAR(36)         DEFAULT NULL     COMMENT 'GUID length is 36 characters',
    `ForgotTokenGenDate`     DATETIME            DEFAULT NULL,
    `AvatarID`               BIGINT UNSIGNED     DEFAULT NULL,

    CONSTRAINT    `PK_Account`           PRIMARY KEY (`ID`),
    CONSTRAINT    `FK_AvatarAccounts`    FOREIGN KEY (`AvatarId`)    REFERENCES `Attachments` (`ID`),
    CONSTRAINT    `UQ_EmailAccounts`     UNIQUE (`Email`)
);

-- Table `Mentors`

DROP TABLE IF EXISTS `Mentors`;

CREATE TABLE `Mentors` (
    `ID`           BIGINT UNSIGNED    NOT NULL     AUTO_INCREMENT,
    `AccountID`    BIGINT UNSIGNED    NOT NULL,

    CONSTRAINT    `PK_Mentor`            PRIMARY KEY (`ID`),
    CONSTRAINT    `FK_AccountMentors`    FOREIGN KEY (`AccountID`)    REFERENCES `Accounts` (`ID`)
);

-- Table `Students`

DROP TABLE IF EXISTS `Students`;

CREATE TABLE `Students` (
    `ID`           BIGINT UNSIGNED    NOT NULL     AUTO_INCREMENT,
    `AccountID`    BIGINT UNSIGNED    NOT NULL,

    CONSTRAINT    `PK_Student`            PRIMARY KEY (`ID`),
    CONSTRAINT    `FK_AccountStudents`    FOREIGN KEY (`AccountID`)    REFERENCES `Accounts` (`ID`)
);

-- Table `Secretaries`

DROP TABLE IF EXISTS `Secretaries`;

CREATE TABLE `Secretaries` (
    `ID`           BIGINT UNSIGNED    NOT NULL     AUTO_INCREMENT,
    `AccountID`    BIGINT UNSIGNED    NOT NULL,

    CONSTRAINT    `PK_Secretary`               PRIMARY KEY (`ID`),
    CONSTRAINT    `FK_AccountSecretaries`      FOREIGN KEY (`AccountID`)    REFERENCES `Accounts` (`ID`)
);

-- Table `Courses`

DROP TABLE IF EXISTS `Courses`;

CREATE TABLE `Courses` (
    `ID`          BIGINT UNSIGNED    NOT NULL      AUTO_INCREMENT,
    `Name`        VARCHAR(100)       NOT NULL,
    `IsActive`    BIT                DEFAULT 1,

    CONSTRAINT    `PK_Course`         PRIMARY KEY (`ID`),
    CONSTRAINT    `UQ_NameCourses`    UNIQUE (`Name`)
);

-- Table `MentorsOfCourses`

DROP TABLE IF EXISTS `MentorsOfCourses`;

CREATE TABLE `MentorsOfCourses` (
    `ID`          BIGINT UNSIGNED    NOT NULL     AUTO_INCREMENT,
    `MentorID`    BIGINT UNSIGNED    NOT NULL,
    `CourseID`    BIGINT UNSIGNED    NOT NULL,

    CONSTRAINT    `PK_MentorOfCourse`                     PRIMARY KEY (`ID`),
    CONSTRAINT    `FK_MentorMentorsOfCourses`             FOREIGN KEY (`MentorID`)           REFERENCES `Mentors` (`ID`),
    CONSTRAINT    `FK_CourseMentorsOfCourses`             FOREIGN KEY (`CourseID`)           REFERENCES `Courses` (`ID`),
    CONSTRAINT    `UQ_MentorAndCourseMentorsOfCourses`    UNIQUE (`MentorID`, `CourseID`)
);

-- Table `StudentGroups`

DROP TABLE IF EXISTS `StudentGroups`;

CREATE TABLE `StudentGroups` (
    `ID`            BIGINT UNSIGNED    NOT NULL     AUTO_INCREMENT,
    `CourseID`      BIGINT UNSIGNED    NOT NULL,
    `Name`          VARCHAR(100)       NOT NULL,
    `StartDate`     DATE               NOT NULL,
    `FinishDate`    DATE               NOT NULL,

    CONSTRAINT    `PK_StudentGroup`           PRIMARY KEY (`ID`),
    CONSTRAINT    `FK_CourseStudentGroups`    FOREIGN KEY (`CourseID`)    REFERENCES `Courses` (`ID`),
    CONSTRAINT    `UQ_NameStudentGroups`      UNIQUE (`Name`)
);

-- Table `StudentsOfStudentGroups`

DROP TABLE IF EXISTS `StudentsOfStudentGroups`;

CREATE TABLE `StudentsOfStudentGroups` (
    `ID`                BIGINT UNSIGNED    NOT NULL         AUTO_INCREMENT,
    `StudentGroupID`    BIGINT UNSIGNED    NOT NULL,
    `StudentID`         BIGINT UNSIGNED    NOT NULL,

    CONSTRAINT    `PK_StudentOfStudentGroup`                  PRIMARY KEY (`ID`),
    CONSTRAINT    `FK_StudentGroupStudentsOfStudentGroups`    FOREIGN KEY (`StudentGroupID`)    REFERENCES `StudentGroups` (`ID`),
    CONSTRAINT    `FK_StudentStudentsOfStudentGroups`         FOREIGN KEY (`StudentID`)         REFERENCES `Students` (`ID`)
);

-- Table `MentorsOfStudentGroups`

DROP TABLE IF EXISTS `MentorsOfStudentGroups`;

CREATE TABLE `MentorsOfStudentGroups` (
    `ID`                BIGINT UNSIGNED    NOT NULL         AUTO_INCREMENT,
    `MentorID`          BIGINT UNSIGNED    NOT NULL,
    `StudentGroupID`    BIGINT UNSIGNED    NOT NULL,

    CONSTRAINT    `PK_MentorOfStudentGroup`                           PRIMARY KEY (`ID`),
    CONSTRAINT    `FK_MentorMentorsOfStudentGroups`                   FOREIGN KEY (`MentorID`)                 REFERENCES `Mentors` (`ID`),
    CONSTRAINT    `FK_StudentGroupMentorsOfStudentGroups`             FOREIGN KEY (`StudentGroupID`)           REFERENCES `StudentGroups` (`ID`),
    CONSTRAINT    `UQ_MentorAndStudentGroupMentorsOfStudentGroups`    UNIQUE (`MentorID`, `StudentGroupID`)
);

-- Table `Themes`

DROP TABLE IF EXISTS `Themes`;

CREATE TABLE `Themes` (
    `ID`      BIGINT UNSIGNED    NOT NULL     AUTO_INCREMENT,
    `Name`    VARCHAR(100)       NOT NULL,

    CONSTRAINT    `PK_Theme`         PRIMARY KEY (`ID`),
    CONSTRAINT    `UQ_NameThemes`    UNIQUE (`Name`)
);

-- Table `Lessons`

DROP TABLE IF EXISTS `Lessons`;

CREATE TABLE `Lessons` (
    `ID`                BIGINT UNSIGNED    NOT NULL     AUTO_INCREMENT,
    `MentorID`          BIGINT UNSIGNED    NOT NULL,
    `StudentGroupID`    BIGINT UNSIGNED    NOT NULL,
    `ThemeID`           BIGINT UNSIGNED    NOT NULL,
    `LessonDate`        DATETIME           NOT NULL,

    CONSTRAINT    `PK_Lesson`                 PRIMARY KEY (`ID`),
    CONSTRAINT    `FK_MentorLessons`          FOREIGN KEY (`MentorID`)          REFERENCES `Mentors` (`ID`),
    CONSTRAINT    `FK_StudentGroupLessons`    FOREIGN KEY (`StudentGroupID`)    REFERENCES `StudentGroups` (`ID`),
    CONSTRAINT    `FK_ThemeLessons`           FOREIGN KEY (`ThemeID`)           REFERENCES `Themes` (`ID`)
);

-- Table `Visits`

DROP TABLE IF EXISTS `Visits`;

CREATE TABLE `Visits` (
    `ID`             BIGINT UNSIGNED     NOT NULL         AUTO_INCREMENT,
    `StudentID`      BIGINT UNSIGNED     NOT NULL,
    `LessonID`       BIGINT UNSIGNED     NOT NULL,
    `StudentMark`    TINYINT UNSIGNED    DEFAULT NULL,
    `Presence`       BIT                 DEFAULT 1,
    `Comment`        VARCHAR(1024)       DEFAULT NULL,

    CONSTRAINT    `PK_Visit`            PRIMARY KEY (`ID`),
    CONSTRAINT    `FK_StudentVisits`    FOREIGN KEY (`StudentID`)           REFERENCES `Students` (`ID`),
    CONSTRAINT    `FK_LessonVisits`     FOREIGN KEY (`LessonID`)            REFERENCES `Lessons` (`ID`),
    CONSTRAINT    `CH_MarkVisits`       CHECK (`StudentMark` >= 0
                                               AND `StudentMark` <= 100)
);

-- Table `Homework`

DROP TABLE IF EXISTS `Homeworks`;

CREATE TABLE IF NOT EXISTS `Homeworks` (
    `ID`          BIGINT UNSIGNED    NOT NULL     AUTO_INCREMENT,
    `DueDate`     DATETIME           NOT NULL,
    `TaskText`    TEXT               NOT NULL,
    `LessonID`    BIGINT UNSIGNED    NOT NULL,

    CONSTRAINT    `PK_Homework`           PRIMARY KEY (`ID`),
    CONSTRAINT    `FK_LessonHomeworks`    FOREIGN KEY (`LessonID`)    REFERENCES `Lessons` (`ID`)    ON DELETE RESTRICT,

    INDEX    `IX_Lesson`    (`LessonID` ASC)
);

-- Table `AttachmentsOfHomeworks`

DROP TABLE IF EXISTS `AttachmentsOfHomeworks`;

CREATE TABLE `AttachmentsOfHomeworks` (
    `ID`              BIGINT UNSIGNED    NOT NULL     AUTO_INCREMENT,
    `HomeworkID`      BIGINT UNSIGNED    NOT NULL,
    `AttachmentID`    BIGINT UNSIGNED    NOT NULL,

    CONSTRAINT    `PK_AttachmentOfHomework`                PRIMARY KEY (`ID`),
    CONSTRAINT    `FK_AttachmentAttachmentsOfHomeworks`    FOREIGN KEY (`AttachmentID`)    REFERENCES `Attachments` (`ID`),
    CONSTRAINT    `FK_HomeworkAttachmentsOfHomeworks`      FOREIGN KEY (`HomeworkID`)      REFERENCES `Homeworks` (`ID`)
);

-- Table `HomeworksFromStudents`

DROP TABLE IF EXISTS `HomeworksFromStudents`;

CREATE TABLE IF NOT EXISTS `HomeworksFromStudents` (
    `ID`              BIGINT UNSIGNED    NOT NULL         AUTO_INCREMENT,
    `StudentID`       BIGINT UNSIGNED    NOT NULL,
    `HomeworkText`    TEXT               DEFAULT NULL,
    `HomeworkID`      BIGINT UNSIGNED    NOT NULL,

    CONSTRAINT    `PK_HomeworkFromStudent`              PRIMARY KEY (`ID`),
    CONSTRAINT    `FK_StudentHomeworksFromStudents`     FOREIGN KEY (`StudentID`)     REFERENCES `Students` (`ID`),
    CONSTRAINT    `FK_HomeworkHomeworksFromStudents`    FOREIGN KEY (`HomeworkID`)    REFERENCES `Homeworks` (`ID`),

    INDEX    `IX_Homework`    (`HomeworkID` ASC)
);

-- Table `AttachmentsOfHomeworksFromStudents`

DROP TABLE IF EXISTS `AttachmentsOfHomeworksFromStudents`;

CREATE TABLE IF NOT EXISTS `AttachmentsOfHomeworksFromStudents` (
    `ID`                       BIGINT UNSIGNED    NOT NULL     AUTO_INCREMENT,
    `AttachmentID`             BIGINT UNSIGNED    NOT NULL,
    `HomeworkFromStudentID`    BIGINT UNSIGNED    NOT NULL,

    CONSTRAINT    `PK_AttachmentOfHomeworkFromStudent`                          PRIMARY KEY (`ID`),
    CONSTRAINT    `FK_AttachmentAttachmentsOfHomeworksFromStudents`             FOREIGN KEY (`AttachmentID`)             REFERENCES `Attachments` (`ID`),
    CONSTRAINT    `FK_HomeworkFromStudentAttachmentsOfHomeworksFromStudents`    FOREIGN KEY (`HomeworkFromStudentID`)    REFERENCES `HomeworksFromStudents` (`ID`),

    INDEX    `IX_HomeworkFromStudent`    (`HomeworkFromStudentID` ASC),
    INDEX    `IX_Attachment`             (`AttachmentID` ASC)
);

-- Table `EventOccurrences`

DROP TABLE IF EXISTS `EventOccurrences`;

CREATE TABLE `EventOccurrences` (
    `ID`                BIGINT UNSIGNED     NOT NULL        AUTO_INCREMENT,
    `StudentGroupID`    BIGINT UNSIGNED     NOT NULL,
    `EventStart`        DATETIME            NOT NULL,
    `EventFinish`       DATETIME            NOT NULL,
    `Pattern`           TINYINT UNSIGNED    DEFAULT NULL    COMMENT 'Patterns:\n 0 - Daily,\n 1 - Weekly,\n 2 - AbsoluteMonthly,\n 3 - RelativeMonthly',
    `Storage`           BIGINT UNSIGNED     NOT NULL,

    CONSTRAINT    `PK_EventOccurrence`                 PRIMARY KEY (`ID`),
    CONSTRAINT    `FK_StudentGroupEventOccurrences`    FOREIGN KEY (`StudentGroupID`)    REFERENCES `StudentGroups` (`ID`)    ON DELETE CASCADE
);

-- Table `ScheduledEvents`

DROP TABLE IF EXISTS `ScheduledEvents`;

CREATE TABLE `ScheduledEvents` (
    `ID`                   BIGINT UNSIGNED    NOT NULL     AUTO_INCREMENT,
    `EventOccurrenceID`    BIGINT UNSIGNED    NOT NULL,
    `StudentGroupID`       BIGINT UNSIGNED    NOT NULL,
    `ThemeID`              BIGINT UNSIGNED    NOT NULL,
    `MentorID`             BIGINT UNSIGNED    NOT NULL,
    `LessonID`             BIGINT UNSIGNED    NOT NULL,
    `EventStart`           DATETIME           NOT NULL,
    `EventFinish`          DATETIME           NOT NULL,

    CONSTRAINT    `PK_ScheduledEvent`                    PRIMARY KEY (`ID`),
    CONSTRAINT    `FK_EventOccurrenceScheduledEvents`    FOREIGN KEY (`EventOccurrenceID`)    REFERENCES `EventOccurrences` (`ID`)    ON DELETE CASCADE,
    CONSTRAINT    `FK_LessonScheduledEvents`             FOREIGN KEY (`LessonID`)             REFERENCES `Lessons` (`ID`),
    CONSTRAINT    `FK_MentorScheduledEvents`             FOREIGN KEY (`MentorID`)             REFERENCES `Mentors` (`ID`),
    CONSTRAINT    `FK_StudentGroupScheduledEvents`       FOREIGN KEY (`StudentGroupID`)       REFERENCES `StudentGroups` (`ID`),
    CONSTRAINT    `FK_ThemeScheduledEvents`              FOREIGN KEY (`ThemeID`)              REFERENCES `Themes` (`ID`),
    CONSTRAINT    `UQ_LessonScheduledEvents`             UNIQUE (`LessonID`)
);
