-- Ola Data Analysis Project

USE ola_project;

ALTER TABLE ola_bookings_cleaned_data_csv
DROP COLUMN MyUnknownColumn;

ALTER TABLE ola_bookings_cleaned_data_csv
DROP COLUMN `Vehicle Images` ;

-- SQL Questions
--  1. Retrieve all successful bookings:

SELECT *
FROM ola_bookings_cleaned_data_csv
WHERE Booking_Status = 'Success';

--  2. Find the average ride distance for each vehicle type:
SELECT Vehicle_Type,AVG(Ride_Distance)as Avg_Ride_Distance
FROM ola_bookings_cleaned_data_csv
GROUP BY Vehicle_Type
ORDER BY 1;

--  3. Get the total number of cancelled rides by customers:
SELECT Booking_ID,Customer_ID,Booking_Status
FROM ola_bookings_cleaned_data_csv
WHERE Booking_Status = 'Canceled by Customer';


--  4. List the top 5 customers who booked the highest number of rides:
SELECT Customer_ID, COUNT(Booking_ID) as Total_Rides
FROM ola_bookings_cleaned_data_csv
GROUP BY Customer_ID
ORDER BY Total_Rides DESC
LIMIT 5;


--  5. Get the number of rides cancelled by drivers due to personal and car-related issues:
SELECT Booking_ID, Canceled_Rides_by_Driver
FROM ola_bookings_cleaned_data_csv
WHERE Canceled_Rides_by_Driver = 'Personal & Car related issue';


--  6. Find the maximum and minimum driver ratings for Prime Sedan bookings:
SELECT Vehicle_Type, MAX(Driver_Ratings) as Max_Rating,
 MIN(Driver_Ratings) as Min_Rating
FROM ola_bookings_cleaned_data_csv
WHERE Vehicle_Type = 'Prime Sedan';


--  7. Retrieve all rides where payment was made using UPI:
SELECT Booking_ID,Customer_ID,Payment_Method
FROM ola_bookings_cleaned_data_csv
WHERE Payment_Method = 'UPI';


--  8. Find the average customer rating per vehicle type:
SELECT Vehicle_Type, AVG(Customer_Rating) as Avg_Customer_Rating
FROM ola_bookings_cleaned_data_csv
GROUP BY Vehicle_Type;

--  9. Calculate the total booking value of rides completed successfully:
SELECT Booking_ID, Booking_Status,(Booking_Value) as Successful_Booking_Value
FROM ola_bookings_cleaned_data_csv
WHERE Booking_Status = 'Success';

--  10. List all incomplete rides along with the reason:
SELECT Booking_ID, Booking_Status,Incomplete_Rides
FROM ola_bookings_cleaned_data_csv
WHERE Incomplete_Rides = 'Yes';