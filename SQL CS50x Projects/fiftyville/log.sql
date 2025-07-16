--Find the crime scene description--
SELECT id, description FROM crime_scene_reports WHERE month = 7 AND day = 28 AND street = 'Humphrey Street';

--Description--
Theft of the CS50 duck took place at 10:15am at the Humphrey Street bakery. Interviews were conducted today with three witnesses who were present at the time
each of their interview transcripts mentions the bakery. || Littering took place at 16:36. No known witnesses.

--Go deeper into the interviews--
SELECT id,name,transcript FROM interviews WHERE month = 7 AND day = 28 AND year = 2023;

--Transcripts
Ruth    | Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away. If you have security footage from the bakery parking lot, you might
          want to look for cars that left the parking lot in that time frame.
Eugene  | I dont know the thiefs name, but it was someone I recognized. Earlier this morning, before I arrived at Emmas bakery, I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.
Raymond | As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow.
          The thief then asked the person on the other end of the phone to purchase the flight ticket.

--Check the bakery_security_logs--
SELECT activity, license_plate
 FROM bakery_security_logs
 WHERE year = 2023 AND month = 7 AND day = 28 AND (hour = 10 AND minute BETWEEN 15 AND 25);

--Transcripts
+----------+---------------+
| activity | license_plate |
+----------+---------------+
| exit     | 5P2BI95       |
| exit     | 94KL13X       |
| exit     | 6P58WS2       |
| exit     | 4328GD8       |
| exit     | G412CB7       |
| exit     | L93JTIZ       |
| exit     | 322W7JE       |
| exit     | 0NTHK55       |
+----------+---------------+

--Check the atm_transactions
SELECT account_number, amount
 FROM atm_transactions
 WHERE year = 2023 AND month = 7 AND day = 28 AND atm_location = 'Leggett Street' AND transaction_type = 'withdraw';

--Transcripts
+----------------+--------+
| account_number | amount |
+----------------+--------+
| 28500762       | 48     |
| 28296815       | 20     |
| 76054385       | 60     |
| 49610011       | 50     |
| 16153065       | 80     |
| 25506511       | 20     |
| 81061156       | 30     |
| 26013199       | 35     |
+----------------+--------+

--Check phone_calls
SELECT caller, receiver FROM phone_calls WHERE duration < 60 AND year = 2023 AND month = 7 AND day = 28;

--Transcripts
+----------------+----------------+
|     caller     |    receiver    |
+----------------+----------------+
| (367) 555-5533 | (375) 555-8161 |
| (770) 555-1861 | (725) 555-3243 |
+----------------+----------------+

--Check for suspects in people
SELECT name, phone_number, people.license_plate, passport_number
 FROM people
 JOIN bakery_security_logs ON people.license_plate = bakery_security_logs.license_plate
 WHERE people.id IN
 (SELECT person_id
 FROM bank_accounts
 WHERE account_number IN
 (SELECT account_number
 FROM atm_transactions
 WHERE year = 2023 AND month = 7 AND day = 28 AND atm_location = 'Leggett Street' AND transaction_type = 'withdraw'));

 --Transcripts
 +---------+----------------+---------------+-----------------+
|  name   |  phone_number  | license_plate | passport_number |
+---------+----------------+---------------+-----------------+
| Diana   | (770) 555-1861 | 322W7JE       | 3592750733      |
| Bruce   | (367) 555-5533 | 94KL13X       | 5773159633      |
+---------+----------------+---------------+-----------------+
+-------+----------------+---------------+-----------------+
| name  |  phone_number  | license_plate | passport_number |
+-------+----------------+---------------+-----------------+
| Robin | (375) 555-8161 | 4V16VO0       | NULL            | <- Bruce called
+-------+----------------+---------------+-----------------+
+--------+----------------+---------------+-----------------+
|  name  |  phone_number  | license_plate | passport_number |
+--------+----------------+---------------+-----------------+
| Philip | (725) 555-3243 | GW362R6       | 3391710505      | <- Diana called
+--------+----------------+---------------+-----------------+

+------+----------------+-----------------+---------------+
| name |  phone_number  | passport_number | license_plate |
+------+----------------+-----------------+---------------+
| Luca | (389) 555-5198 | 8496433585      | 4328GD8       |
+------+----------------+-----------------+---------------+
SELECT name, phone_number, license_plate, passport_number
 FROM people
 WHERE phone_number = '(375) 555-8161';

--Check bank accounts
SELECT name FROM people WHERE id
 = (SELECT person_id
 FROM bank_accounts
 WHERE account_number IN (SELECT account_number
 FROM atm_transactions

 WHERE year = 2023 AND month = 7 AND day = 28 AND atm_location = 'Leggett Street' AND transaction_type = 'withdraw'));

--Check passengers/airports/flights
SELECT full_name, city FROM airports WHERE id IN
 (SELECT destination_airport_id FROM flights WHERE id IN (SELECT flight_id FROM passengers WHERE passport_number = 5773159633));






