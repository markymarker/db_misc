-- Mark Fletcher
-- vim: syn=pg

-- Handy pages:
-- https://www.postgresql.org/docs/current/queries-table-expressions.html
-- https://www.postgresql.org/docs/9.1/queries-with.html


-- 1)
-- Combine two array literals into a single temp table
-- Fills in missing spots for either with NULL
SELECT
  arr_pos, number, letter
FROM
  ROWS FROM (
    UNNEST(ARRAY['a', 'b', 'c']),
    UNNEST(ARRAY[5, 4, 3, 2, 1])
  ) WITH ORDINALITY AS combo (letter, number, arr_pos)
;

-- 1.1)
-- Equivalent to (1), using special functionality of UNNEST instead
SELECT
  arr_pos, number, letter
FROM
  UNNEST(
    ARRAY['a', 'b', 'c'],
    ARRAY[5, 4, 3, 2, 1]
  ) WITH ORDINALITY AS combo (letter, number, arr_pos)
;

-- 1.2)
-- Equivalent to (1), defining values in json and using json_to_recordset
SELECT
  arr_pos, number, letter
FROM
  ROWS FROM (
    json_to_recordset('[
      {"n":5, "l":"a"},
      {"n":4, "l":"b"},
      {"n":3, "l":"c"},
      {"n":2, "l":null},
      {"n":1, "l":null}
    ]') AS (n integer, l text)
  ) WITH ORDINALITY AS combo (number, letter, arr_pos)
;


-- 2)
-- Testing the row_to_json function with named columns
-- The column names are used for the key names in the result
SELECT
  row_to_json(t.*)
FROM (VALUES
  (42, ARRAY[3, 2, 1], 'hi')
) AS t (ca, cb, cc)
;


-- 3)
-- Just testing using various things in combination
-- Result is string: db2
SELECT
  array_to_string(array_agg(c), '')
FROM (
  SELECT
    cb AS c
  FROM (VALUES
    ('a', 'b'),
    ('c', 'd'),
    ('1', '2')
  ) AS t (ca, cb)
  ORDER BY c DESC
) t
;


-- 4)
-- Idea: According to the page:
--   https://www.postgresql.org/docs/9.1/queries-with.html
-- section:
--   7.8.2. Data-Modifying Statements in WITH
-- the outer query does not see the modifications made by the inner query.
--
-- Therefore, it may be possible to exploit this behavior for an audit table strategy.
-- Something based on the following could achieve saving both the old and new values
-- in one shot. (Following is probably not valid in itself.)
WITH t AS (
  UPDATE table_a
  SET value = $newvalue
  WHERE uniq_col = 'param'
  RETURNING *
)
INSERT INTO audit_table (
  old_value,
  new_value
)
VALUES (
  row_to_json(SELECT * FROM table_a WHERE uniq_col = 'param'),
  row_to_json(t.*)
)
;

