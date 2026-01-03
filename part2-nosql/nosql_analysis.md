# NoSQL Database Analysis for FlexiMart

## Section A: Limitations of RDBMS (Relational Databases)

Relational databases such as MySQL are based on a rigid, predefined schema, which makes them difficult to adapt when dealing with highly diverse and evolving product data. In the case of FlexiMart, different product categories require completely different attributes. For example, laptops require technical specifications like RAM, processor type, storage capacity, and graphics card, whereas shoes require attributes such as size, color, material, and gender. In a relational model, handling this diversity would either require creating many nullable columns in a single table or maintaining multiple category-specific tables. Both approaches increase schema complexity and reduce efficiency.

Another major limitation is the need for frequent schema changes. Whenever FlexiMart introduces a new product type or adds new attributes, the database schema must be modified using ALTER TABLE operations. These schema changes can be expensive in terms of performance, especially when the database grows large, and may lead to system downtime or data migration issues.

Additionally, relational databases are not well suited for storing nested or hierarchical data such as customer reviews. Reviews naturally belong to a product and often include nested information like ratings, comments, timestamps, and reviewer details. In an RDBMS, this requires separate tables and multiple joins, which increases query complexity and negatively impacts performance as data volume increases.

---

## Section B: Benefits of Using MongoDB

MongoDB, a document-oriented NoSQL database, effectively addresses these challenges through its flexible schema design. Unlike relational databases, MongoDB does not require a fixed schema. Each product can be stored as a document with attributes specific to its category. This allows FlexiMart to store laptops, shoes, accessories, and future product types within the same collection without restructuring the database. New attributes can be added dynamically, making the system highly adaptable to changing business requirements.

MongoDB also supports embedded documents, which makes it particularly suitable for handling customer reviews. Reviews can be stored directly inside the product document as nested arrays, including reviewer information, ratings, comments, and timestamps. This design closely matches real-world data representation and eliminates the need for complex joins, resulting in faster read operations and simpler queries.

Furthermore, MongoDB is built for horizontal scalability. It supports sharding, which distributes data across multiple servers. As FlexiMart’s product catalog and user base grow, MongoDB can scale out by adding more nodes rather than relying on vertical scaling. This ensures high availability, fault tolerance, and consistent performance even under heavy workloads.

---

## Section C: Trade-offs of Using MongoDB

Despite its advantages, MongoDB also has certain disadvantages when compared to relational databases like MySQL. One key limitation is weaker enforcement of data consistency. Since MongoDB allows flexible schemas, there is a higher risk of inconsistent or poorly structured data unless strict validation rules are implemented at the application level.

Another drawback is that MongoDB is less suitable for complex transactional operations. Although modern versions of MongoDB support multi-document transactions, they are generally less efficient and more complex than traditional ACID-compliant transactions in relational databases. This makes MongoDB less ideal for scenarios requiring strong transactional guarantees, such as financial accounting or payment processing systems.
