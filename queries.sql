/*Queries that provide answers to the questions from all projects.*/

-- Find all animals whose name ends in "mon".
SELECT * from animals WHERE name LIKE '%mon';

-- List the name of all animals born between 2016 and 2019.
SELECT * from animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT * FROM animals WHERE neutered = true AND escape_attempts < 3;

-- List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';

-- List name and escape attempts of animals that weigh more than 10.5kg.
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

-- Find all animals that are neutered.
SELECT * FROM animals WHERE neutered = true;

-- Find all animals not named Gabumon.
SELECT * FROM animals WHERE name NOT IN ('Gabumon');

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- Update the animals table by setting the species column to unspecified and verify the change was made.
BEGIN TRANSACTION;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
-- Roll back the change and verify that the species columns went back to the state before the transaction.
ROLLBACK TRANSACTION;
SELECT * FROM animals;

-- Another Transaction for setting species.
BEGIN TRANSACTION;
UPDATE animals SET species = 'digimon' WHERE name LIKE  '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL OR species = '';
SELECT * FROM animals;
COMMIT TRANSACTION;
SELECT * FROM animals;

-- Deleting all records from animals table and rolling back.
BEGIN TRANSACTION;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK TRANSACTION;
SELECT * FROM animals;

-- Another transaction for deletion and updating the table.
BEGIN TRANSACTION;
DELETE FROM animals
WHERE date_of_birth > '2022-01-01';
SAVEPOINT SP1;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO SP1;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT TRANSACTION;
SELECT * FROM animals;

-- Queries to answer questions
-- How many animals are there?
SELECT COUNT(*) FROM animals;
-- How many animals have never tried to escape?
SELECT count(*) FROM animals WHERE escape_attempts = 0;
-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;
-- Who escapes the most, neutered or not neutered animals?
SELECT neutered,
  SUM(escape_attempts) AS most_escape
FROM animals
GROUP BY neutered
ORDER BY most_escape DESC;
-- What is the minimum and maximum weight of each type of animal?
SELECT
  species,
  MIN(weight_kg) AS min_weight,
  MAX(weight_kg) AS max_weight
FROM animals
GROUP BY species;
-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT
  species,
  AVG(escape_attempts) AS avg_escape_attempts
FROM  animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

-- Writing queries (using JOIN) to answer questions:
-- What animals belong to Melody Pond?
SELECT animals.*
FROM animals
INNER JOIN owners
ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';
-- List of all animals that are pokemon (their type is Pokemon).
SELECT animals.*
FROM animals
INNER JOIN species
ON animals.species_id = species.id
WHERE species.name = 'Pokemon';
-- List all owners and their animals.
SELECT
  full_name,
  name
FROM owners
FULL JOIN animals
ON  owners.id = animals.owner_id;
-- How many animals are there per species?
SELECT
  species.name,
  count(*)
FROM animals
INNER JOIN species
ON animals.species_id = species.id
GROUP BY species.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT
  animals.name,
  owners.full_name AS owner_full_name,
  species.name AS species_name
FROM animals
INNER JOIN species
ON animals.species_id = species.id
INNER JOIN owners
ON animals.owner_id = owners.id
WHERE owners.full_name = 'Jennifer Orwell' AND species.name = 'Digimon';
-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT
  animals.name,
  animals.escape_attempts,
  owners.full_name AS owner_full_name
FROM animals
INNER JOIN owners
ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;
-- Who owns the most animals?
SELECT
  owners.full_name,
  COUNT(*)
FROM animals
FULL JOIN owners
ON animals.owner_id = owners.id
GROUP BY owners.full_name
ORDER BY COUNT(*) DESC
LIMIT 1;

-- Writing queries to answer questions
-- Who was the last animal seen by William Tatcher?
SELECT
  vets.name AS vet_name,
  animals.name AS animal_name,
  visits.visit_date AS visit_date
FROM visits
INNER JOIN animals ON visits.animal_id = animals.id
INNER JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'William Tatcher'
ORDER BY visit_date DESC
LIMIT 1;
-- How many different animals did Stephanie Mendez see?
SELECT
  vets.name AS vet_name,
  COUNT(DISTINCT animals.id) AS different_animals_count
FROM visits
INNER JOIN vets ON visits.vet_id = vets.id
INNER JOIN animals ON visits.animal_id = animals.id
WHERE vets.name = 'Stephanie Mendez'
GROUP BY vets.name;
-- List all vets and their specialties, including vets with no specialties.
SELECT
  vets.name AS vet_name,
  species.name AS specialty
FROM specializations
FULL JOIN vets ON specializations.vet_id = vets.id
FULL JOIN species ON specializations.species_id = species.id;
-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT
  vets.name AS vet_name,
  animals.name AS animal_name,
  visits.visit_date AS visit_date
FROM visits
INNER JOIN vets ON visits.vet_id = vets.id
INNER JOIN animals ON visits.animal_id = animals.id
WHERE vets.name = 'Stephanie Mendez' AND visit_date BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT
  animals.name AS animal_name,
  COUNT(visits.animal_id) AS visit_times
FROM visits
INNER JOIN animals ON visits.animal_id = animals.id
GROUP BY animal_name
ORDER BY visit_times DESC
LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT
  vets.name AS vet_name,
  animals.name AS animal_name,
  visits.visit_date AS visit_date
FROM visits
INNER JOIN vets ON visits.vet_id = vets.id
INNER JOIN animals ON visits.animal_id = animals.id
WHERE vets.name = 'Maisy Smith'
ORDER BY visit_date ASC
LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT
  animals.name AS animal_name,
  animals.date_of_birth AS animal_date_of_birth,
  animals.escape_attempts AS animal_escape_attempts,
  animals.neutered AS neutered,
  animals.weight_kg AS animal_weight_kg,
  vets.name AS vet_name,
  vets.age AS vet_age,
  vets.date_of_graduation AS vet_date_of_graduation,
  visits.visit_date AS visit_date
FROM visits
INNER JOIN vets ON visits.vet_id = vets.id
INNER JOIN animals ON visits.animal_id = animals.id
ORDER BY visit_date DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT
  vets.name AS vet_name,
  COUNT(*) AS visit_times
FROM visits
INNER JOIN vets ON visits.vet_id = vets.id
INNER JOIN animals ON visits.animal_id = animals.id
LEFT JOIN specializations ON vets.id = specializations.vet_id
WHERE specializations.vet_id IS NULL
GROUP BY vet_name;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT s.name AS specialty, COUNT(*) AS total_visits_for_specialty
FROM species s
INNER JOIN animals a ON s.id = a.species_id
INNER JOIN visits v ON a.id = v.animal_id
INNER JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'Maisy Smith'
GROUP BY s.name
ORDER BY total_visits_for_specialty DESC
LIMIT 1;

