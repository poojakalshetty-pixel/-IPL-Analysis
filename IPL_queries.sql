Query 1: 
Top 5 teams with most wins

SELECT winner, COUNT(*) as total_wins
FROM matches
WHERE winner IS NOT NULL
GROUP BY winner
ORDER BY total_wins DESC
LIMIT 5;

 Query 2:
 Toss decision impact on match wins

SELECT toss_decision, COUNT(*) as total_wins
FROM matches
WHERE winner = toss_winner
GROUP BY toss_decision
ORDER BY total_wins DESC;

 Query 3:
 Most successful team per season

SELECT season, winner, COUNT(*) as wins
FROM matches
WHERE winner IS NOT NULL
GROUP BY season, winner
ORDER BY season, wins DESC;

 Query 4:
 Top 10 cities with most matches

SELECT city, COUNT(*) as total_matches
FROM matches
WHERE city IS NOT NULL
GROUP BY city
ORDER BY total_matches DESC
LIMIT 10;

 Query 5: 
Player of the match awards (Top 10)

SELECT player_of_match, COUNT(*) as awards
FROM matches
WHERE player_of_match IS NOT NULL
GROUP BY player_of_match
ORDER BY awards DESC
LIMIT 10;

Query 6:
 Top 10 batsmen by total runs (JOIN)

SELECT d.batter, SUM(d.batsman_runs) as total_runs
FROM deliveries d
JOIN matches m ON d.match_id = m.id
GROUP BY d.batter
ORDER BY total_runs DESC
LIMIT 10;

Query 7: 
Top 10 bowlers by wickets

SELECT d.bowler, COUNT(*) as total_wickets
FROM deliveries d
WHERE d.is_wicket = 1
AND d.dismissal_kind NOT IN ('run out', 'retired hurt', 'obstructing the field')
GROUP BY d.bowler
ORDER BY total_wickets DESC
LIMIT 10;

Query 8:
 Win type analysis (runs vs wickets)

SELECT 
    CASE 
        WHEN result = 'runs' THEN 'Won by Runs'
        WHEN result = 'wickets' THEN 'Won by Wickets'
        ELSE 'Other'
    END as win_type,
    COUNT(*) as total_matches
FROM matches
WHERE result IS NOT NULL
GROUP BY win_type
ORDER BY total_matches DESC;

Query 9: 
Teams that won more than average wins

SELECT winner, COUNT(*) as total_wins
FROM matches
WHERE winner IS NOT NULL
GROUP BY winner
HAVING COUNT(*) > (
    SELECT AVG(win_count) 
    FROM (
        SELECT COUNT(*) as win_count 
        FROM matches 
        WHERE winner IS NOT NULL 
        GROUP BY winner
    ) as avg_wins
)
ORDER BY total_wins DESC;

Query 10: 
Season wise top scorer using window function

SELECT season, batter, total_runs, player_rank
FROM (
    SELECT m.season, d.batter, SUM(d.batsman_runs) as total_runs,
    RANK() OVER (PARTITION BY m.season ORDER BY SUM(d.batsman_runs) DESC) as player_rank
    FROM deliveries d
    JOIN matches m ON d.match_id = m.id
    GROUP BY m.season, d.batter
) as season_runs
WHERE player_rank = 1
ORDER BY season;