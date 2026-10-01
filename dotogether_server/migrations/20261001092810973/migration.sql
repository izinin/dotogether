BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "app_user_data" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "app_user_data" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "phoneNumber" text NOT NULL,
    "displayName" text NOT NULL,
    "deviceToken" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "app_user_data_auth_user_idx" ON "app_user_data" USING btree ("authUserId");
CREATE INDEX "app_user_data_phone_idx" ON "app_user_data" USING btree ("phoneNumber");

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
    "ownerId" uuid NOT NULL,
    "ownerPhone" text,
    "executorId" uuid,
    "assigneePhone" text NOT NULL,
    "ownerName" text NOT NULL,
    "assigneeName" text NOT NULL,
    "overallStatus" text NOT NULL DEFAULT 'pending'::text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "project_owner_id_idx" ON "project" USING btree ("ownerId");
CREATE INDEX "project_executor_id_idx" ON "project" USING btree ("executorId");
CREATE INDEX "project_assignee_phone_idx" ON "project" USING btree ("assigneePhone");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "app_user_data"
    ADD CONSTRAINT "app_user_data_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
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
    VALUES ('dotogether', '20261001092810973', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261001092810973', "timestamp" = now();

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
