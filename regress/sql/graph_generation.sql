/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */


LOAD 'age';

SET search_path = ag_catalog;

-- TESTS FOR COMPLETE GRAPH GENERATION

SELECT * FROM create_complete_graph(
    'gp1', 5,
    'edges', '{"edge_property":"test"}'::agtype,
    'vertices', '{"node_property":"test"}'::agtype);

SELECT COUNT(*) FROM gp1."edges";
SELECT COUNT(*) FROM gp1."vertices";

SELECT * FROM cypher('gp1', $$MATCH (a) RETURN a$$) as (vertexes agtype);
SELECT * FROM cypher('gp1', $$MATCH (a)-[e]->(b) RETURN e$$) as (edges agtype);

SELECT * FROM create_complete_graph(
    'gp1', 5,
    'edges', '{"type":"edge","connection":"strong"}'::agtype,
    'vertices', '{"type":"node"}'::agtype);

SELECT COUNT(*) FROM gp1."edges";
SELECT COUNT(*) FROM gp1."vertices";

SELECT * FROM create_complete_graph(
    'gp2',7,
    'edges', '{"type":"edge"}'::agtype,
    'vertices', '{"type":"node"}'::agtype);


-- SHOULD FAIL

-- NULL graph name
SELECT * FROM create_complete_graph(NULL,NULL,NULL);

-- NULL number of nodes
SELECT * FROM create_complete_graph(
    'gp3',NULL,
    'edges','{"prop":"any"}'::agtype,
    'vertices', '{"prop":"any"}'::agtype);

-- NULL edge label
SELECT * FROM create_complete_graph(
    'gp4',5, 
    NULL,'{"prop":"any"}'::agtype,
    'vertices', '{"prop":"any"}'::agtype);

-- Should error out because same labels are used for both vertices and edges
SELECT * FROM create_complete_graph(
    'gp5',5,
    'label','{"edge_prop":"any"}'::agtype,
    'label','{"node_prop":"any"}'::agtype);

-- DROPPING GRAPHS
SELECT drop_graph('gp1', true);
SELECT drop_graph('gp2', true);

