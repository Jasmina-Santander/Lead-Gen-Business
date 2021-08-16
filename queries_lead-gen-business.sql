/*1. ¿Qué consulta ejecutaría para obtener los ingresos totales para marzo de 2012?*/
select  
	monthname(charged_datetime) as 'month',
	sum(billing.amount) as total_revenue
	from billing 
	where charged_datetime >= '2012/03/01' and charged_datetime < '2012/03/31';
    
/*2. ¿Qué consulta ejecutaría para obtener los ingresos totales recaudados del cliente con una identificación de 2?*/
select
	 billing.client_id, 
	 sum(billing.amount) as total_revenue
		from billing 
		where client_id = '2';
        
/*3. ¿Qué consulta ejecutaría para obtener todos los sitios que posee client = 10? */
select
	 domain_name AS website,
	 sites.client_id
		from sites
		where client_id = '10';

/*4.  ¿Qué consulta ejecutaría para obtener el número total de sitios creados
 por mes por año para el cliente con una identificación de 1? ¿Qué pasa con el cliente = 20? */
 /* Clientes identificacion 1 */
 select
 client_id, 
 count(domain_name) as number_of_websites, 
 monthname(created_datetime) as 'month', 
 year(created_datetime) as 'year'
    from sites
    where client_id = '1'
    group by month(sites.created_datetime)
     order by sites.created_datetime desc;
     
 /* Clientes identificacion 20 */
  select
 client_id, 
 count(domain_name) as number_of_websites, 
 monthname(created_datetime) as 'month', 
 year(created_datetime) as 'year'
    from sites
    where client_id = '20'
    group by month(sites.created_datetime)
     order by sites.created_datetime desc;
     
 /* Clientes identificacion 1 y 20 */
select
 client_id, 
 count(domain_name) as number_of_websites, 
 monthname(created_datetime) as 'month', 
 year(created_datetime) as 'year'
    from sites 
    where (client_id = '1') or (client_id = '20')
    group by month(sites.created_datetime)
     order by sites.created_datetime desc;
	
     
/* 5. ¿Qué consulta ejecutaría para obtener el número total de clientes
 potenciales generados para cada uno de los sitios entre el 1 de enero de 2011 y el 15 de febrero de 2011? */
 select 
	 domain_name as website,
	 date_format(registered_datetime,"%M %d %Y") as date_generated,
	 count(leads.leads_id) as number_of_leads
		from sites
		left join leads on sites.site_id = leads.site_id
		where registered_datetime >= '2011/01/01' and registered_datetime < '2011/02/15'
		group by sites.domain_name;
        
/* 6. ¿Qué consulta ejecutaría para obtener una lista de nombres de clientes y el número total de clientes 
potenciales que hemos generado para cada uno de nuestros clientes entre el 1 de enero de 2011 y el 31 de diciembre de 2011? */
select 
 concat(clients.first_name," ", clients.last_name) as client_name, 
 count(leads.leads_id)
    from clients
    left join sites on clients.client_id = sites.client_id
    left join leads on sites.site_id = leads.site_id
    where registered_datetime >= '2011/01/01' and registered_datetime < '2011/12/31'
    group by clients.client_id
    order by count(leads.leads_id) desc;

/* 7. ¿Qué consulta ejecutaría para obtener una lista de nombres de clientes y el número total de clientes potenciales que hemos
 generado para cada cliente cada mes entre los meses 1 y 6 del año 2011? */
select 
concat(clients.first_name," ", clients.last_name) as client_name, 
count(leads_id) AS number_of_leads, date_format(registered_datetime,"%M") as month
    from clients
    left join sites on clients.client_id = sites.client_id
    left join leads on sites.site_id = leads.site_id
    where (registered_datetime >= '2011/01/01') and (registered_datetime < '2011/06/30')
    group by registered_datetime;
  

/* 8. ¿Qué consulta ejecutaría para obtener una lista de nombres de clientes y el número total de clientes potenciales que hemos generado para cada uno de los sitios de nuestros clientes entre
 el 1 de enero de 2011 y el 31 de diciembre de 2011? Solicite esta consulta por ID de cliente. Presente una segunda consulta que muestre todos los clientes, los nombres del sitio y el número
 total de clientes potenciales generados en cada sitio en todo momento.*/
select
 concat(clients.first_name," ", clients.last_name) as client_name,
 domain_name as website, 
 count(leads_id) as number_of_leads, 
 date_format(registered_datetime,"%M %d %Y") as date_generated
    from sites
    left join leads on sites.site_id = leads.site_id
    LEFT JOIN clients on clients.client_id = sites.client_id
    where registered_datetime >= '2011/01/01' and registered_datetime < '2011/12/31'
    group by sites.domain_name
    order by clients.client_id, count(leads.leads_id) desc;

/*Segunda Consulta*/
select 
	concat(clients.first_name," ", clients.last_name) as client_name, 
	domain_name as website,
	 count(leads_id) AS number_of_leads, 
	 date_format(registered_datetime,"%M %d %Y") as date_generated
		from sites
		left join leads on sites.site_id = leads.site_id
		left join clients on clients.client_id = sites.client_id
		group by sites.domain_name
		order by clients.client_id, count(leads.leads_id) desc;

/* 9. Escriba una sola consulta que recupere los ingresos totales recaudados de cada cliente para cada mes del año. Pídalo por ID de cliente. */
select
 concat(clients.first_name," ", clients.last_name) as client_name,
 sum(billing.amount) AS total_revenue, date_format(charged_datetime,"%M") as month, 
 date_format(charged_datetime,"%Y") AS year_charge
    from billing
    left join clients on billing.client_id = clients.client_id
    group by billing.charged_datetime
    order by  clients.client_id, charged_datetime asc;

/*10. Escriba una sola consulta que recupere todos los sitios que posee cada cliente. Agrupe los resultados para que cada 
fila muestre un nuevo cliente. Se volverá más claro cuando agregue un nuevo campo 
llamado 'sitios' que tiene todos los sitios que posee el cliente. (SUGERENCIA: use GROUP_CONCAT) */
select
 concat(clients.first_name," ", clients.last_name) as client_name,
 GROUP_CONCAT(" ", domain_name) as sites
    from sites
    left join clients on clients.client_id = sites.client_id
    group by clients.client_id;




