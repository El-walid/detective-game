import { PrismaClient, GroupMode, PaymentProvider, OrderStatus, LocationType, EvidenceCategory, PersonStatus } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
    console.log('Seeding database with Case #409...');

    // 1. Create the Case
    const harborCase = await prisma.case.create({
        data: {
            title: "The Harbor Warehouse Murder",
            price: 4.99,
            difficulty_tier: 2,
            client_name: "Elena Vance",
            initial_notification: "My husband was found dead at Dock 4. The police ruled it a suicide, but I know he was murdered. Please find the truth.",
            is_published: true,
        }
    });

    // 2. Create the Victim (Person)
    const victim = await prisma.person.create({
        data: {
            case_id: harborCase.id,
            subject_id: "CID-88392",
            full_name: "VANCE, MARCUS",
            aliases: ["Marky"],
            dob: "08/14/1984",
            age: 42,
            sex: "M",
            race: "W",
            height: "180cm",
            weight: "185 lbs",
            hair_color: "BRN",
            eye_color: "HZL",
            scars_marks_tattoos: "Appendectomy scar on abdomen",
            status: PersonStatus.VICTIM,
            warrants: [],
            caution_codes: ["DECEASED"], // A good tag for the frontend to highlight
            last_known_address: "14B Baker Ave",
            registered_vehicles: ["2018 Ford F-150 (ABC-9876)"],
            occupation: "Warehouse Manager",
            employer: "Harbor Logistics",
            known_associates: ["VANCE, ELENA (Wife)"],
            criminal_history: [] // NO PRIOR RECORD
        }
    });

    const civilian = await prisma.person.create({
        data: {
            case_id: harborCase.id,
            subject_id: "CID-11024",
            full_name: "VANCE, ELENA",
            aliases: [], // Empty array
            dob: "04/22/1991",
            age: 35,
            sex: "F",
            race: "W",
            height: "5'6\"",
            weight: "130 lbs",
            hair_color: "BRN",
            eye_color: "GRN",
            scars_marks_tattoos: "NONE VISIBLE",
            status: PersonStatus.CITIZEN,
            warrants: [], // No warrants
            caution_codes: [], // System Status: CLEAR / NO FLAGS
            last_known_address: "1042 Ocean View Dr, Apt 3B (Source: DMV)",
            registered_vehicles: ["2022 Honda Civic (License: XYZ-1234)"],
            occupation: "Graphic Designer",
            employer: "Studio 54 (Sourced via tax records)",
            known_associates: [], // NO CRIMINAL AFFILIATIONS ON FILE
            criminal_history: []  // NO PRIOR RECORD (0)
        }
    });

    // 3. Create the Crime Scene (Location)
    const dockLocation = await prisma.location.create({
        data: {
            case_id: harborCase.id,
            name: "Dock 4 Warehouse",
            exact_address: "Pier 4, Industrial District",
            normalized_search_key: "pier 4 industrial district",
            location_type: LocationType.CRIME_SCENE,
            map_coords: { x: 450, y: 320 }
        }
    });

    // 4. Create Evidence at the Scene
    await prisma.evidence.create({
        data: {
            location_id: dockLocation.id,
            name: "Shattered Pocket Watch",
            category: EvidenceCategory.PERSONAL,
            short_description: "A smashed gold watch stopped exactly at 02:14 AM.",
            hotspot_coords: { x_pct: 65, y_pct: 80, r_pct: 5 },
            relevance_score: 20
        }
    });

    console.log('Seed completed successfully!');
}

main()
    .catch((e) => {
        console.error(e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });