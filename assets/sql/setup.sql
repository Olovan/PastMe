CREATE TABLE Note
(
    id INTEGER PRIMARY KEY,
    title TEXT,
    body TEXT
)

CREATE TABLE ActionItem
(
    id INTEGER PRIMARY KEY,
    description TEXT,
    done BOOLEAN,
    parent INT, 
);