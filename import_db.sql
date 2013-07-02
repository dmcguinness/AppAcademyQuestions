CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255),
  lname VARCHAR(255)
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255),
  body VARCHAR(255),
  user_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  question_id INTEGER,
  user_id INTEGER,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255),
  body VARCHAR(255),
  question_id INTEGER,
  user_id INTEGER,
  reply_id INTEGER,


  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER,
  user_id INTEGER,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE tags (
  id INTEGER PRIMARY KEY,
  tag VARCHAR(255),
  question_id INTEGER,

  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE question_tags (
  id INTEGER PRIMARY KEY,
  tag_id INTEGER,
  question_id INTEGER,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (tag_id) REFERENCES tags(id)
);


INSERT INTO users ('fname', 'lname')
     VALUES ('Jin', 'Park'),
            ('Dan', 'McGuinness');


INSERT INTO questions ('title', 'body', user_id)
     VALUES ('SQLite has a boolean?', 'SQLite has a boolean? Maybe bit?', 1),
            ('What is your name!?', 'I dont even know you??', 2);

INSERT INTO question_followers (question_id, user_id)
     VALUES (2, 1),
            (1, 2);

INSERT INTO replies ('title', 'body', question_id, user_id, reply_id)
     VALUES ('Bit is bad', 'Use int 0 or 1', 1, 2, null),
            ('I am not sure', 'How do you know what your name is?', 2, 1, null),
            ('Bit is good', 'Use bit for boolean stuff', 1, 1, 1);

INSERT INTO question_likes (question_id, user_id)
     VALUES (2, 1),
            (2, 2);

INSERT INTO tags ('tag', 'question_id')
     VALUES ('html', 1),
            ('ruby', 2);

INSERT INTO question_tags ('tag_id', 'question_id')
     VALUES (1, 1),
            (1, 2),
            (2, 2);
