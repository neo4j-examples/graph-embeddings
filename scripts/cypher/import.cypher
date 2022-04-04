CREATE CONSTRAINT places IF NOT EXISTS ON (p:Place) ASSERT p.name IS UNIQUE;
CREATE CONSTRAINT countries IF NOT EXISTS ON (c:Country) ASSERT c.code IS UNIQUE;

LOAD CSV WITH HEADERS FROM "https://github.com/neo4j-examples/graph-embeddings/raw/main/data/roads.csv"
AS row

MERGE (origin:Place {name: row.origin_reference_place})
SET origin.countryCode = row.origin_country_code

MERGE (destination:Place {name: row.destination_reference_place})
SET destination.countryCode = row.destination_country_code

MERGE (c_origin:Country {code: row.origin_country_code})

MERGE (c_destination:Country {code: row.destination_country_code})

MERGE (origin)-[eroad:EROAD {number: row.road_number}]->(destination)
SET eroad.distance = toInteger(row.distance), eroad.watercrossing = row.watercrossing

MERGE (origin)-[:IN_COUNTRY]->(c_origin)
MERGE (destination)-[:IN_COUNTRY]->(c_destination)
;