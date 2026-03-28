use funnel_analytics;

select * from users;
select * from events;
select * from orders;
select * from funnel_user_summary;

SELECT
    sum(visit_flag) as visited_users,
    sum(signup_flag) as signed_up_users,
    sum(activate_flag) as activated_users,
    sum(add_to_cart_flag) as cart_users,
    sum(purchase_flag) as purchased_users
from funnel_user_summary;    

SELECT
    ROUND(SUM(signup_flag) / SUM(visit_flag) * 100, 2) AS visit_to_signup_pct,
    ROUND(SUM(activate_flag) / SUM(signup_flag) * 100, 2) AS signup_to_activate_pct,
    ROUND(SUM(add_to_cart_flag) / SUM(activate_flag) * 100, 2) AS activate_to_cart_pct,
    ROUND(SUM(purchase_flag) / SUM(add_to_cart_flag) * 100, 2) AS cart_to_purchase_pct,
    ROUND(SUM(purchase_flag) / SUM(visit_flag) * 100, 2) AS overall_conversion_pct
FROM funnel_user_summary;

SELECT
    ROUND((SUM(visit_flag) - SUM(signup_flag)) / SUM(visit_flag) * 100, 2) AS drop_visit_to_signup,
    ROUND((SUM(signup_flag) - SUM(activate_flag)) / SUM(signup_flag) * 100, 2) AS drop_signup_to_activate,
    ROUND((SUM(activate_flag) - SUM(add_to_cart_flag)) / SUM(activate_flag) * 100, 2) AS drop_activate_to_cart,
    ROUND((SUM(add_to_cart_flag) - SUM(purchase_flag)) / SUM(add_to_cart_flag) * 100, 2) AS drop_cart_to_purchase
FROM funnel_user_summary;

SELECT
    device,
    COUNT(*) AS users,
    SUM(purchase_flag) AS purchasers,
    ROUND(SUM(purchase_flag) / COUNT(*) * 100, 2) AS conversion_pct,
    ROUND(SUM(total_revenue), 2) AS revenue
FROM funnel_user_summary
GROUP BY device
ORDER BY conversion_pct DESC;

SELECT
    channel,
    COUNT(*) AS users,
    SUM(purchase_flag) AS purchasers,
    ROUND(SUM(purchase_flag) / COUNT(*) * 100, 2) AS conversion_pct,
    ROUND(SUM(total_revenue), 2) AS revenue
FROM funnel_user_summary
GROUP BY channel
ORDER BY conversion_pct DESC;

SELECT
    country,
    COUNT(*) AS users,
    SUM(purchase_flag) AS purchasers,
    ROUND(SUM(purchase_flag) / COUNT(*) * 100, 2) AS conversion_pct,
    ROUND(SUM(total_revenue), 2) AS revenue
FROM funnel_user_summary
GROUP BY country
ORDER BY revenue DESC;

SELECT
    ROUND(AVG(days_visit_to_signup), 2) AS avg_days_visit_to_signup,
    ROUND(AVG(days_signup_to_activate), 2) AS avg_days_signup_to_activate,
    ROUND(AVG(days_activate_to_cart), 2) AS avg_days_activate_to_cart,
    ROUND(AVG(days_cart_to_purchase), 2) AS avg_days_cart_to_purchase,
    ROUND(AVG(days_visit_to_purchase), 2) AS avg_days_visit_to_purchase
FROM funnel_user_summary
WHERE purchase_flag = 1;

SELECT
    channel,
    device,
    country,
    COUNT(*) AS users,
    SUM(purchase_flag) AS purchasers,
    ROUND(SUM(purchase_flag) / COUNT(*) * 100, 2) AS conversion_pct,
    ROUND(SUM(total_revenue), 2) AS revenue
FROM funnel_user_summary
GROUP BY channel, device, country
HAVING COUNT(*) >= 50
ORDER BY conversion_pct DESC, revenue DESC
LIMIT 15;

SELECT
    max_stage_reached,
    COUNT(*) AS users,
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM funnel_user_summary
GROUP BY max_stage_reached
ORDER BY total_revenue DESC;

SELECT
    ROUND(
        (SUM(add_to_cart_flag) - SUM(purchase_flag))
        *
        AVG(CASE WHEN purchase_flag = 1 THEN avg_order_value END),
        2
    ) AS estimated_lost_revenue
FROM funnel_user_summary;
