-- -----------------------------------------------------
-- Table "table_1_1"
-- -----------------------------------------------------
CREATE TABLE "table_1_1" (
  "id" UUID NOT NULL,
  "reference_to_1" UUID NOT NULL,
  "reference_to_2" UUID NOT NULL,
  "updated_at" TIMESTAMPTZ NOT NULL,
  "data" VARCHAR,
  PRIMARY KEY ("id")
);

CREATE INDEX ON "table_1_1" ("reference");

