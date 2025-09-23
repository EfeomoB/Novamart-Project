---1. Which 3 bundles have the highest subscription volume/count?
SELECT b.bundle_name, b.category, COUNT (s.subscription_id) AS subscription_count
FROM subscriptions s
JOIN bundles b ON s.bundle_id = b.bundle_id
GROUP BY b.bundle_name, b.bundle_id, b.category
ORDER BY subscription_count DESC, b.bundle_name ASC
LIMIT 3;

--- 2. What is the average spend per loyalty tier? Hint: where payment is_successful?
SELECT c.loyalty_tier, AVG (s.total_value) AS avg_spend
FROM public.customers c
JOIN public.subscriptions s ON s.customer_id = c.customer_id
JOIN public.payments p ON p.subscription_id = s.subscription_id
WHERE p.is_successful = TRUE
GROUP BY c.loyalty_tier
ORDER BY avg_spend DESC;

---3. How many payments failed and what methods are used? Hint: where payment_status=failed
SELECT payment_method,
COUNT(*) AS failed_count
FROM public.payments
WHERE LOWER (payment_status) = 'failed'
GROUP BY payment_method
ORDER BY failed_count DESC;

--- 4. What is the total revenue by bundle category? 
---using table (bundle is_active, payment is_successful).
SELECT b.category, 
SUM (s.total_value) AS total_revenue
FROM public.subscriptions s
JOIN public.bundles b ON b.bundle_id = s.bundle_id
JOIN public.payments p ON p.subscription_id = s.subscription_id
WHERE b.is_active = TRUE
AND p.is_successful = TRUE
GROUP BY b.category
ORDER BY total_revenue DESC;

---5. What issue types receive the lowest ratings?
SELECT issue_type,
AVG(rating) AS avg_rating
FROM public.support_tickets
GROUP BY issue_type
ORDER BY avg_rating ASC;