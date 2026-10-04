BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "project" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "project" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "description" text NOT NULL DEFAULT ''::text,
    "ownerId" bigint NOT NULL,
    "assigneeId" bigint NOT NULL,
    "overallStatus" text NOT NULL DEFAULT 'pending'::text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "project_owner_id_idx" ON "project" USING btree ("ownerId");
CREATE INDEX "project_assignee_id_idx" ON "project" USING btree ("assigneeId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "project"
    ADD CONSTRAINT "project_fk_0"
    FOREIGN KEY("ownerId")
    REFERENCES "contact"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "project"
    ADD CONSTRAINT "project_fk_1"
    FOREIGN KEY("assigneeId")
    REFERENCES "contact"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION RESTORE FOREIGN KEY
--
ALTER TABLE ONLY "checklist_item"
    ADD CONSTRAINT "checklist_item_fk_0"
    FOREIGN KEY("projectId")
    REFERENCES "project"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "checklist_item"
    ADD CONSTRAINT "checklist_item_fk_1"
    FOREIGN KEY("_projectChecklistitemsProjectId")
    REFERENCES "project"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION FOR dotogether
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('dotogether', '20261004175621775', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261004175621775', "timestamp" = now();

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
