-- -----------------------------------------------------
-- Table "table_2_1"
-- -----------------------------------------------------
CREATE TABLE "table_2_1" (
  "id" UUID NOT NULL,
  "created_at" TIMESTAMPTZ NOT NULL,
  "data" VARCHAR,
  PRIMARY KEY ("id")
);

CREATE INDEX ON "table_2_1" ("created_at");

