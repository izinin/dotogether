BEGIN;

--
-- DATA CLEANUP (hand-added): make existing rows comply with the new
-- unique constraints on "contact"."ownerId" and "contact"."phoneNumber"
-- before the unique indexes below are created, without losing any rows
-- or breaking "project"."ownerId"/"assigneeId" foreign keys.
--

-- 1. Deduplicate by phoneNumber: keep the oldest row per phone number and
--    repoint any Project references from the discarded duplicate rows to
--    the kept row, then delete the duplicates.
WITH ranked AS (
    SELECT "id", "phoneNumber",
           ROW_NUMBER() OVER (
               PARTITION BY "phoneNumber" ORDER BY "id"
           ) AS rn,
           FIRST_VALUE("id") OVER (
               PARTITION BY "phoneNumber" ORDER BY "id"
           ) AS keep_id
    FROM "contact"
), dupes AS (
    SELECT "id", keep_id FROM ranked WHERE rn > 1
)
UPDATE "project" p
SET "ownerId" = dupes.keep_id
FROM dupes
WHERE p."ownerId" = dupes."id";

WITH ranked AS (
    SELECT "id", "phoneNumber",
           ROW_NUMBER() OVER (
               PARTITION BY "phoneNumber" ORDER BY "id"
           ) AS rn,
           FIRST_VALUE("id") OVER (
               PARTITION BY "phoneNumber" ORDER BY "id"
           ) AS keep_id
    FROM "contact"
), dupes AS (
    SELECT "id", keep_id FROM ranked WHERE rn > 1
)
UPDATE "project" p
SET "assigneeId" = dupes.keep_id
FROM dupes
WHERE p."assigneeId" = dupes."id";

WITH ranked AS (
    SELECT "id",
           ROW_NUMBER() OVER (
               PARTITION BY "phoneNumber" ORDER BY "id"
           ) AS rn
    FROM "contact"
)
DELETE FROM "contact" WHERE "id" IN (SELECT "id" FROM ranked WHERE rn > 1);

-- 2. Deduplicate by ownerId: phoneNumber is now unique, so any remaining
--    "ownerId" duplicates are distinct real-world contacts that merely
--    share the legacy "owner who synced them" value. Keep the first row's
--    "ownerId" as-is and assign each other row in the group a freshly
--    generated, guaranteed-unique "ownerId" (no other column changes).
WITH ranked AS (
    SELECT "id",
           ROW_NUMBER() OVER (
               PARTITION BY "ownerId" ORDER BY "id"
           ) AS rn
    FROM "contact"
)
UPDATE "contact" c
SET "ownerId" = gen_random_uuid()
FROM ranked
WHERE c."id" = ranked."id" AND ranked.rn > 1;

--
-- ACTION ALTER TABLE
--
DROP INDEX "contact_owner_idx";
DROP INDEX "contact_phone_idx";
CREATE UNIQUE INDEX "contact__ownerId__unique_idx" ON "contact" USING btree ("ownerId");
CREATE UNIQUE INDEX "contact__phoneNumber__unique_idx" ON "contact" USING btree ("phoneNumber");

--
-- MIGRATION VERSION FOR dotogether
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('dotogether', '20261006115800516', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261006115800516', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260824182343939', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182343939', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
