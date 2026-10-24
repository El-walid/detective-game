/*
  Warnings:

  - You are about to drop the column `physical_traits` on the `Person` table. All the data in the column will be lost.
  - You are about to drop the column `registered_address` on the `Person` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Person" DROP COLUMN "physical_traits",
DROP COLUMN "registered_address",
ADD COLUMN     "caution_codes" TEXT[],
ADD COLUMN     "dob" TEXT,
ADD COLUMN     "employer" TEXT,
ADD COLUMN     "eye_color" TEXT,
ADD COLUMN     "hair_color" TEXT,
ADD COLUMN     "height" TEXT,
ADD COLUMN     "known_associates" TEXT[],
ADD COLUMN     "last_known_address" TEXT,
ADD COLUMN     "occupation" TEXT,
ADD COLUMN     "race" TEXT,
ADD COLUMN     "registered_vehicles" TEXT[],
ADD COLUMN     "scars_marks_tattoos" TEXT,
ADD COLUMN     "sex" TEXT,
ADD COLUMN     "subject_id" TEXT,
ADD COLUMN     "warrants" TEXT[],
ADD COLUMN     "weight" TEXT;
