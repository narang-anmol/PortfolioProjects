--Data Profiling

	--Number of Columns in Each Table
	
	SELECT table_name, COUNT(*)
	FROM information_schema.columns
	WHERE table_name IN ('aircrafts_data', 'airports_data', 'boarding_passes', 'bookings', 'flights', 'seats', 'ticket_flights', 'tickets')
	GROUP BY table_name
	ORDER BY table_name;

	--Column Names and Their Data Types

	SELECT table_name, column_name, data_type
	FROM information_schema.columns
	WHERE table_name IN ('aircrafts_data', 'airports_data', 'boarding_passes', 'bookings', 'flights', 'seats', 'ticket_flights', 'tickets')
	ORDER BY table_name;
	
--FLight Analysis

	--Most Popular Flight Routes
	
	SELECT departure_airport, arrival_airport, COUNT(*) AS number_of_flights
	FROM flights
	GROUP BY departure_airport, arrival_airport
	ORDER BY number_of_flights DESC;
	
	--Exploring Distribution of Flight Durations
	
	SELECT MIN(actual_arrival - actual_departure) AS min_duration,
   	MAX(actual_arrival - actual_departure) AS max_duration,
    AVG(actual_arrival - actual_departure) AS avg_duration
	FROM flights
	WHERE actual_departure IS NOT NULL AND actual_arrival IS NOT NULL;
	
--Booking Patterns

	--Most Booked FLights
	
	SELECT FL.flight_no, departure_airport, arrival_airport, COUNT(*) AS booking_count
	FROM ticket_flights TF
	INNER JOIN flights FL
	ON TF.flight_id = FL.flight_id
	GROUP BY FL.flight_no, departure_airport, arrival_airport
	ORDER BY booking_count DESC;
	
	--Booking Class Preference
	
	SELECT fare_conditions, COUNT(*) AS booking_count
	FROM ticket_flights
	GROUP BY fare_conditions
	ORDER BY booking_count DESC;
	
	--Booking Month Preference
	
	SELECT EXTRACT(MONTH FROM book_date) AS month, COUNT(*) AS booking_count
	FROM bookings
	GROUP BY month
	ORDER BY booking_count DESC;
	
	--Seat Preference
	
	SELECT seat_no, COUNT(*) AS booking_count
	FROM boarding_passes
	GROUP BY seat_no
	ORDER BY booking_count DESC;
	
	--Seat Preference by Seat Class
	
	SELECT
  	SUBSTRING(seat_no FROM LENGTH(seat_no) FOR 1) AS seat_class,
  	COUNT(*) AS booking_count
	FROM boarding_passes
	GROUP BY seat_class
	ORDER BY booking_count DESC;
	
--Ticket Analysis

	--Distribution of Ticket Prices
	
	SELECT MIN(amount) AS min_price, 
	MAX(amount) AS max_price, 
	AVG(amount) AS avg_price
	FROM ticket_flights;
	
	--Relationship Between Ticket Prices & Flight Numbers
	
	SELECT flight_no, AVG(amount) AS avg_ticket_price
	FROM ticket_flights TF
	INNER JOIN flights FL
	ON TF.flight_id = FL.flight_id
	GROUP BY flight_no
	ORDER BY avg_ticket_price DESC;
	
	--Daily Breakdown of Total Bookings
	
	SELECT 
    CAST(book_date AS DATE) AS booking_day,
    COUNT(*) AS total_bookings
	FROM bookings
	GROUP BY booking_day
	ORDER BY booking_day;
	
--Airport Insights

	--Airport Traffic Distribution
	
	SELECT airport_code, COUNT(*) AS total_flights
	FROM (
    		SELECT departure_airport AS airport_code FROM flights
    		UNION ALL
    		SELECT arrival_airport AS airport_code FROM flights
			) 
			AS all_airports
	GROUP BY airport_code
	ORDER BY total_flights DESC;
	
	--Most Outgoing Flights
	
	SELECT departure_airport, COUNT(*) AS total_flights
	FROM flights
	GROUP BY departure_airport
	ORDER BY total_flights DESC;
	
	--Most Incoming Flights
	
	SELECT arrival_airport, COUNT(*) AS total_flights
	FROM flights
	GROUP BY arrival_airport
	ORDER BY total_flights DESC;
	
	--Distribution of Flight Delays & Cancellations
	
	SELECT status, departure_airport, COUNT(*) AS total_flights
	FROM flights
	WHERE status IN ('Delayed', 'Cancelled')
	GROUP BY status, departure_airport
	ORDER BY status DESC;

--Aircraft Analysis

	--Most & Least Frequently Used Aircrafts
	
	SELECT FL.aircraft_code, AD.model, COUNT(*) AS number_of_flights
	FROM flights FL
	INNER JOIN aircrafts_data AD
	ON FL.aircraft_code = AD.aircraft_code
	GROUP BY AD.model, FL.aircraft_code
	ORDER BY number_of_flights DESC;
	
--Customer Behavior

	--Analyzing Customer Booking Pattern
	
	SELECT passenger_name, COUNT(*) AS booking_count
	FROM tickets
	GROUP BY passenger_name
	ORDER BY booking_count DESC;
	
	--Average Amount Spent by Each Passenger
	
	SELECT passenger_id, ROUND(AVG(total_amount)) AS average_amount_spent
	FROM tickets TI
	INNER JOIN bookings BO
	ON TI.book_ref = BO.book_ref
	GROUP BY passenger_id
	ORDER BY average_amount_spent DESC;
