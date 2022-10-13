DROP TABLE IF EXISTS votes;
DROP TABLE IF EXISTS candidates;
DROP TABLE IF EXISTS parties;
DROP TABLE IF EXISTS voters;

CREATE TABLE parties (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  description TEXT
);

CREATE TABLE candidates (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(30) NOT NULL,
  last_name VARCHAR(30) NOT NULL,
  party_id INTEGER,
  industry_connected BOOLEAN NOT NULL,
  CONSTRAINT fk_party FOREIGN KEY (party_id) REFERENCES parties(id) ON DELETE SET NULL
);

-- When it comes to voters, there is no relation with candidates or parties so we'll create a seperate table for this
CREATE TABLE voters (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(30) NOT NULL,
  last_name VARCHAR(30) NOT NULL,
  email VARCHAR(50) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP -- This will return WHEN the voters were added
);

CREATE TABLE votes (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  voter_id INTEGER NOT NULL,
  candidate_id INTEGER NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uc_voter UNIQUE (voter_id),-- This signifies that the values inserted into the voter_id field must be unique. 
  -- For example, whoever has a voter_id of 1 can only appear in this table once. See below, we excute the following commands to input the voters
  -- INSERT INTO votes (voter_id, candidate_id) VALUES(2, 1);
  -- INSERT INTO votes (voter_id, candidate_id) VALUES(2, 2); < This line would return and errors as the a voter_id of 1 already voted
  CONSTRAINT fk_voter FOREIGN KEY (voter_id) REFERENCES voters(id) ON DELETE CASCADE, -- CASCADE > deleting the reference key will also delete the entire row from this table
  CONSTRAINT fk_candidate FOREIGN KEY (candidate_id) REFERENCES candidates(id) ON DELETE CASCADE
);

-- And as a test of the above CASCADE commands, if we run this in terminal: 
-- DELETE FROM voters WHERE id = 2;
-- SELECT * FROM votes;
-- Rather than the NULL command that makes the value NULL, the full row will be deleted from the votes table if the voter is deleted