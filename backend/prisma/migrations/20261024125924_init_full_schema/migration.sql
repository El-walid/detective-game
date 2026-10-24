-- CreateEnum
CREATE TYPE "GroupMode" AS ENUM ('COOP_SHARED', 'VERSUS_RACE');

-- CreateEnum
CREATE TYPE "PaymentProvider" AS ENUM ('BANK_CARD', 'PAYPAL', 'BINANCE_PAY');

-- CreateEnum
CREATE TYPE "OrderStatus" AS ENUM ('PENDING', 'PAID', 'FAILED', 'REFUND');

-- CreateEnum
CREATE TYPE "LocationType" AS ENUM ('CRIME_SCENE', 'HOUSE', 'SHOP', 'PUBLIC');

-- CreateEnum
CREATE TYPE "EvidenceCategory" AS ENUM ('FORENSICS', 'DOCUMENTS', 'WEAPONS', 'PERSONAL', 'DIGITAL');

-- CreateEnum
CREATE TYPE "PersonStatus" AS ENUM ('CITIZEN', 'SUSPECT', 'VICTIM', 'WANTED', 'DECEASED', 'IN_CUSTODY');

-- CreateEnum
CREATE TYPE "SessionStatus" AS ENUM ('ACTIVE', 'CLOSED');

-- CreateEnum
CREATE TYPE "VerdictType" AS ENUM ('TRUE_KILLER_CONVICTED', 'KILLER_WALKED_WEAK_PROOF', 'ACCOMPLICE_ONLY', 'INNOCENT_WRONGFULLY_CONVICTED', 'INNOCENT_ACQUITTED_IN_COURT');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "country" VARCHAR(2),
    "points" INTEGER NOT NULL DEFAULT 0,
    "cases_purchased_count" INTEGER NOT NULL DEFAULT 0,
    "cases_solved_count" INTEGER NOT NULL DEFAULT 0,
    "group_id" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Group" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "invite_code" TEXT NOT NULL,
    "leader_user_id" TEXT NOT NULL,
    "mode" "GroupMode" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Group_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Order" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "payment_provider" "PaymentProvider",
    "provider_tx_id" TEXT,
    "total_amount" DECIMAL(10,2) NOT NULL,
    "currency" VARCHAR(10),
    "status" "OrderStatus",
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "paid_at" TIMESTAMP(3),

    CONSTRAINT "Order_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrderLine" (
    "id" TEXT NOT NULL,
    "order_id" TEXT NOT NULL,
    "case_id" TEXT NOT NULL,
    "unit_price" DECIMAL(10,2) NOT NULL,
    "discount_applied" DECIMAL(10,2) NOT NULL DEFAULT 0,

    CONSTRAINT "OrderLine_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Case" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "price" DECIMAL(10,2) NOT NULL,
    "difficulty_tier" INTEGER NOT NULL,
    "client_name" TEXT,
    "initial_notification" TEXT,
    "is_published" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Case_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Location" (
    "id" TEXT NOT NULL,
    "case_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "exact_address" TEXT NOT NULL,
    "normalized_search_key" TEXT,
    "map_coords" JSONB,
    "location_type" "LocationType",
    "scene_image_url" TEXT,
    "present_npc_id" TEXT,

    CONSTRAINT "Location_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Evidence" (
    "id" TEXT NOT NULL,
    "location_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "category" "EvidenceCategory",
    "short_description" TEXT,
    "thumbnail_url" TEXT,
    "inspect_image_url" TEXT,
    "hotspot_coords" JSONB,
    "requires_scope" BOOLEAN NOT NULL DEFAULT false,
    "relevance_score" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "Evidence_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Person" (
    "id" TEXT NOT NULL,
    "case_id" TEXT NOT NULL,
    "full_name" TEXT NOT NULL,
    "aliases" TEXT[],
    "age" INTEGER,
    "registered_address" TEXT,
    "physical_traits" JSONB,
    "status" "PersonStatus",
    "criminal_history" JSONB,
    "mugshot_url" TEXT,
    "dialogue_data" JSONB,

    CONSTRAINT "Person_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Autopsy" (
    "id" TEXT NOT NULL,
    "case_id" TEXT NOT NULL,
    "victim_person_id" TEXT NOT NULL,
    "coroner_name" TEXT,
    "body_diagram_url" TEXT,
    "estimated_tod_window" TEXT,
    "toxicology_raw" TEXT,
    "stomach_contents" TEXT,
    "anatomical_markers" JSONB,

    CONSTRAINT "Autopsy_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PlayerCaseSession" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "group_id" TEXT,
    "case_id" TEXT NOT NULL,
    "status" "SessionStatus",
    "unlocked_location_ids" TEXT[],
    "started_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PlayerCaseSession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CollectedEvidence" (
    "id" TEXT NOT NULL,
    "session_id" TEXT NOT NULL,
    "evidence_id" TEXT NOT NULL,
    "player_note" TEXT,
    "added_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CollectedEvidence_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PlayerAutopsyNote" (
    "id" TEXT NOT NULL,
    "session_id" TEXT NOT NULL,
    "autopsy_id" TEXT NOT NULL,
    "marker_id" TEXT,
    "observation_note" TEXT,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PlayerAutopsyNote_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CaseEnding" (
    "id" TEXT NOT NULL,
    "case_id" TEXT NOT NULL,
    "accused_person_id" TEXT NOT NULL,
    "verdict_type" "VerdictType",
    "min_proof_score_req" INTEGER,
    "ending_title" TEXT,
    "epilogue_narrative" TEXT,
    "base_points_awarded" INTEGER,
    "expected_keywords" TEXT[],

    CONSTRAINT "CaseEnding_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CaseSubmission" (
    "id" TEXT NOT NULL,
    "session_id" TEXT NOT NULL,
    "accused_person_id" TEXT NOT NULL,
    "supporting_evidence_ids" TEXT[],
    "explanation_text" TEXT,
    "ending_triggered_id" TEXT NOT NULL,
    "points_earned" INTEGER,
    "submitted_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CaseSubmission_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Group_invite_code_key" ON "Group"("invite_code");

-- CreateIndex
CREATE UNIQUE INDEX "Autopsy_victim_person_id_key" ON "Autopsy"("victim_person_id");

-- CreateIndex
CREATE UNIQUE INDEX "CaseSubmission_session_id_key" ON "CaseSubmission"("session_id");

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "Group"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Group" ADD CONSTRAINT "Group_leader_user_id_fkey" FOREIGN KEY ("leader_user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Order" ADD CONSTRAINT "Order_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrderLine" ADD CONSTRAINT "OrderLine_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "Order"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrderLine" ADD CONSTRAINT "OrderLine_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "Case"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Location" ADD CONSTRAINT "Location_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "Case"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Location" ADD CONSTRAINT "Location_present_npc_id_fkey" FOREIGN KEY ("present_npc_id") REFERENCES "Person"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Evidence" ADD CONSTRAINT "Evidence_location_id_fkey" FOREIGN KEY ("location_id") REFERENCES "Location"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Person" ADD CONSTRAINT "Person_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "Case"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Autopsy" ADD CONSTRAINT "Autopsy_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "Case"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Autopsy" ADD CONSTRAINT "Autopsy_victim_person_id_fkey" FOREIGN KEY ("victim_person_id") REFERENCES "Person"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerCaseSession" ADD CONSTRAINT "PlayerCaseSession_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerCaseSession" ADD CONSTRAINT "PlayerCaseSession_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "Group"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerCaseSession" ADD CONSTRAINT "PlayerCaseSession_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "Case"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CollectedEvidence" ADD CONSTRAINT "CollectedEvidence_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "PlayerCaseSession"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CollectedEvidence" ADD CONSTRAINT "CollectedEvidence_evidence_id_fkey" FOREIGN KEY ("evidence_id") REFERENCES "Evidence"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerAutopsyNote" ADD CONSTRAINT "PlayerAutopsyNote_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "PlayerCaseSession"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerAutopsyNote" ADD CONSTRAINT "PlayerAutopsyNote_autopsy_id_fkey" FOREIGN KEY ("autopsy_id") REFERENCES "Autopsy"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CaseEnding" ADD CONSTRAINT "CaseEnding_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "Case"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CaseEnding" ADD CONSTRAINT "CaseEnding_accused_person_id_fkey" FOREIGN KEY ("accused_person_id") REFERENCES "Person"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CaseSubmission" ADD CONSTRAINT "CaseSubmission_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "PlayerCaseSession"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CaseSubmission" ADD CONSTRAINT "CaseSubmission_accused_person_id_fkey" FOREIGN KEY ("accused_person_id") REFERENCES "Person"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CaseSubmission" ADD CONSTRAINT "CaseSubmission_ending_triggered_id_fkey" FOREIGN KEY ("ending_triggered_id") REFERENCES "CaseEnding"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
