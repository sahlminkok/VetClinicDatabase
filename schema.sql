/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  date_of_birth DATE NOT NULL,
  escape_attempts INT NOT NULL,
  neutered BOOLEAN NOT NULL,
  weight_kg DECIMAL(4, 2) NOT NULL,
  PRIMARY KEY (id)
);

-- Add a column species
ALTER TABLE animals
ADD species VARCHAR(255);

--Create owners table
CREATE TABLE owners (
  id INT GENERATED ALWAYS AS IDENTITY,
  full_name VARCHAR(255),
  age INT,
  PRIMARY KEY (id)
);

--Create species table
CREATE TABLE species (
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255),
  PRIMARY KEY (id)
);

--Modify animals table
--Remove species column
ALTER TABLE animals
DROP COLUMN species;
--Add species_id column
ALTER TABLE animals
ADD COLUMN species_id INT;
-- Add a foreign key referencing species table to the species_id column
ALTER TABLE animals
ADD CONSTRAINT fk_species_id
FOREIGN KEY (species_id)
REFERENCES species (id)
ON DELETE CASCADE;
-- Add owner_id column
ALTER TABLE animals
ADD COLUMN owner_id INT;
-- Add a foreign key referencing owners table to the owners_id column
ALTER TABLE animals
ADD CONSTRAINT fk_owner_id
FOREIGN KEY (owner_id)
REFERENCES owners (id)
ON DELETE CASCADE;
