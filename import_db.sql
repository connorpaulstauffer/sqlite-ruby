DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,
  FOREIGN KEY(author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  follower_id INTEGER NOT NULL,
  FOREIGN KEY(question_id) REFERENCES question(id),
  FOREIGN KEY(follower_id) REFERENCES users(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  FOREIGN KEY(question_id) REFERENCES question(id),
  FOREIGN KEY(parent_id) REFERENCES replies(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY(question_id) REFERENCES question(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);

INSERT INTO
  users(fname, lname)
VALUES
  ('Ned', 'Ruggeri'), ('Eric', 'Schwarzenbach');

INSERT INTO
  questions(title, body, author_id)
VALUES
  ('what is homework', 'w3d3 stuff',
   (SELECT id FROM users WHERE lname = 'Ruggeri')),
  ('what is the color of grass', 'i really don''t know',
   (SELECT id FROM users WHERE lname = 'Schwarzenbach')) ;

INSERT INTO
  question_follows (question_id, follower_id)
VALUES
  ((SELECT id FROM questions WHERE title = 'what is homework'),
   (SELECT id FROM users WHERE lname = 'Ruggeri')
  ),
  ((SELECT id FROM questions WHERE title = 'what is the color of grass'),
   (SELECT id FROM users WHERE lname = 'Schwarzenbach')
   );

INSERT INTO
  replies (body, question_id, parent_id, user_id)
VALUES
  ('sql exercises', (SELECT id FROM questions WHERE title = 'what is homework'),
   NULL, (SELECT id FROM users WHERE lname = 'Schwarzenbach'));

 INSERT INTO
   replies (body, question_id, parent_id, user_id)
 VALUES
   ('ok', (SELECT id FROM questions WHERE title = 'what is homework'),
    (SELECT id FROM replies WHERE body = 'sql exercises'),
    (SELECT id FROM users WHERE lname = 'Ruggeri'));

INSERT INTO
  question_likes (question_id, user_id)
VALUES
  ((SELECT id FROM questions WHERE title = 'what is homework'),
   (SELECT id FROM users WHERE lname = 'Schwarzenbach')
 );
