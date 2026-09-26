BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "app_user_data" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "phoneNumber" text,
    "deviceToken" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "app_user_data_auth_user_idx" ON "app_user_data" USING btree ("authUserId");
CREATE INDEX "app_user_data_phone_idx" ON "app_user_data" USING btree ("phoneNumber");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "checklist_item" (
    "id" bigserial PRIMARY KEY,
    "projectId" bigint NOT NULL,
    "title" text NOT NULL,
    "isCompleted" boolean NOT NULL DEFAULT false,
    "sortOrder" bigint NOT NULL DEFAULT 0,
    "completedAt" timestamp without time zone,
    "_projectChecklistitemsProjectId" bigint
);

-- Indexes
CREATE INDEX "checklist_item_project_idx" ON "checklist_item" USING btree ("projectId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "contact" (
    "id" bigserial PRIMARY KEY,
    "ownerId" uuid NOT NULL,
    "name" text NOT NULL,
    "phoneNumber" text NOT NULL,
    "isRegistered" boolean NOT NULL DEFAULT false,
    "registeredUserId" uuid,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "contact_owner_idx" ON "contact" USING btree ("ownerId");
CREATE INDEX "contact_phone_idx" ON "contact" USING btree ("phoneNumber");

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
    "assigneeName" text NOT NULL,
    "overallStatus" text NOT NULL DEFAULT 'pending'::text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "project_owner_id_idx" ON "project" USING btree ("ownerId");
CREATE INDEX "project_executor_id_idx" ON "project" USING btree ("executorId");
CREATE INDEX "project_assignee_phone_idx" ON "project" USING btree ("assigneePhone");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_key" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "hash" text NOT NULL,
    "scopeNames" json NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_auth_key_userId_idx" ON "serverpod_auth_key" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_email_auth" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "email" text NOT NULL,
    "hash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_auth_email" ON "serverpod_email_auth" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_email_create_request" (
    "id" bigserial PRIMARY KEY,
    "userName" text NOT NULL,
    "email" text NOT NULL,
    "hash" text NOT NULL,
    "verificationCode" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_auth_create_account_request_idx" ON "serverpod_email_create_request" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_email_failed_sign_in" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "ipAddress" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_email_failed_sign_in_email_idx" ON "serverpod_email_failed_sign_in" USING btree ("email");
CREATE INDEX "serverpod_email_failed_sign_in_time_idx" ON "serverpod_email_failed_sign_in" USING btree ("time");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_email_reset" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "verificationCode" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_reset_verification_idx" ON "serverpod_email_reset" USING btree ("verificationCode");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_google_refresh_token" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "refreshToken" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_google_refresh_token_userId_idx" ON "serverpod_google_refresh_token" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_user_image" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "version" bigint NOT NULL,
    "url" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_user_image_user_id" ON "serverpod_user_image" USING btree ("userId", "version");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_user_info" (
    "id" bigserial PRIMARY KEY,
    "userIdentifier" text NOT NULL,
    "userName" text,
    "fullName" text,
    "email" text,
    "created" timestamp without time zone NOT NULL,
    "imageUrl" text,
    "scopeNames" json NOT NULL,
    "blocked" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_user_info_user_identifier" ON "serverpod_user_info" USING btree ("userIdentifier");
CREATE INDEX "serverpod_user_info_email" ON "serverpod_user_info" USING btree ("email");

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
-- ACTION CREATE FOREIGN KEY
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
    VALUES ('dotogether', '20260926145709599', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260926145709599', "timestamp" = now();

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
