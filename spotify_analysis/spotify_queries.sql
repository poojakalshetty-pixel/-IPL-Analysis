CREATE TABLE spotify (
    id INTEGER,
    track_id VARCHAR(50),
    artists TEXT,
    album_name TEXT,
    track_name TEXT,
    popularity INTEGER,
    duration_ms INTEGER,
    explicit BOOLEAN,
    danceability FLOAT,
    energy FLOAT,
    key INTEGER,
    loudness FLOAT,
    mode INTEGER,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    time_signature INTEGER,
    track_genre VARCHAR(50)
);

COPY spotify(id, track_id, artists, album_name, track_name, popularity, duration_ms, explicit, danceability, energy, key, loudness, mode, speechiness, acousticness, instrumentalness, liveness, valence, tempo, time_signature, track_genre)
FROM 'C:\dataset.csv'
WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8', QUOTE '"', ESCAPE '"');

SELECT COUNT(*) FROM spotify;


select track_genre , avg (popularity)
from spotify 
group by track_genre 
order by avg (popularity) desc;

select artists , avg(popularity)
from spotify 
group by artists 
order by avg (popularity) desc 
limit 10;

SELECT explicit, AVG(popularity), COUNT(*)
FROM spotify
GROUP BY EXPLICIT 
ORDER BY AVG(POPULARITY) DESC; 

SELECT track_name, artists, AVG(popularity)
FROM spotify 
GROUP BY track_name, artists
ORDER BY AVG(popularity) DESC
LIMIT 10;

SELECT track_genre, COUNT(*)
FROM spotify
GROUP BY TRACK_GENRE 
ORDER BY COUNT(*) DESC ;


SELECT AVG(popularity) FROM spotify
SELECT track_name, artists, popularity
FROM spotify
WHERE popularity > (SELECT AVG(popularity) FROM spotify)
LIMIT 20;

CREATE TABLE genre_info (
    track_genre VARCHAR(50),
    mood TEXT
);

INSERT INTO genre_info VALUES
('pop-film', 'Happy & Upbeat'),
('k-pop', 'Energetic'),
('indie-pop', 'Chill & Mellow'),
('acoustic', 'Calm & Soothing'),
('anime', 'Dramatic');

SELECT s.track_name, s.track_genre, g.mood
FROM spotify s
JOIN genre_info g
ON s.track_genre = g.track_genre
LIMIT 10;

SELECT track_name, artists, track_genre, popularity,
RANK() OVER (PARTITION BY track_genre ORDER BY popularity DESC) as rank
FROM spotify
LIMIT 20;



