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
