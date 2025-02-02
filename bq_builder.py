###
# Copyright 2024, ISB
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###
import re
from google.api_core.exceptions import BadRequest

bq_proj_dataset = "{projectId}.{dataset}".format(projectId='nih-nci-cbiit-tp53-dev', dataset='P53_data')


def set_project_dataset(proj_id="nih-nci-cbiit-tp53-dev", d_set="P53_data"):
    global bq_proj_dataset
    bq_proj_dataset = "{projectId}.{dataset}".format(projectId=proj_id, dataset=d_set)


def build_group_sum_graph_query(criteria, view, group_by):
    query_temp = """
        SELECT {group_by} AS LABEL, SUM(Sample_analyzed) AS Sample_analyzed_SUM, SUM(Sample_mutated) AS Sample_mutated_SUM
        FROM `{bq_proj_dataset}.{view}`	
        WHERE {where_clause}
        GROUP BY {group_by}
        ORDER BY (Sample_mutated_SUM/Sample_analyzed_SUM) DESC
    """
    where_clause = build_where_clause(criteria)
    query = query_temp.format(
        bq_proj_dataset=bq_proj_dataset,
        view=view,
        group_by=group_by,
        where_clause=where_clause,
    )
    return query


def build_mutation_rate_query(criteria_map, table, label_by="Effect"):
    label_alias = "AS LABEL"
    query_module = """
            SELECT *
            FROM `{bq_proj_dataset}.{table}`	
            WHERE {where_clause}
        """

    count_query = """
            SELECT AAchange AS NAME, LOG(Mut_rateAA) AS RATE, Effect {effect}, SIFTClass {sift}, TransactivationClass {taclass}, COUNT(AAchange) AS CNT
            FROM ({filtered_select_sql})
            GROUP BY AAchange, Mut_rateAA, Effect, SIFTClass, TransactivationClass
            ORDER BY CNT DESC
    """

    if not criteria_map or len(criteria_map) == 0:
        criteria_map = criteria_map or {"include": [], "exclude": []}
    filtered_select_sql = ""
    for type in ["include", "exclude"]:
        if type == "include":
            filtered_select_sql += query_module
            where_clause = build_where_clause(criteria_map[type], include=True)
        elif len(criteria_map[type]):
            filtered_select_sql += "\nEXCEPT DISTINCT ("
            filtered_select_sql += query_module
            filtered_select_sql += "\n)"
            where_clause = build_where_clause(criteria_map[type], include=False)
        else:
            where_clause = ""

        if where_clause:
            filtered_select_sql = filtered_select_sql.format(
                bq_proj_dataset=bq_proj_dataset, table=table, where_clause=where_clause
            )
    effect = ""
    sift = ""
    taclass = ""

    if label_by == "TransactivationClass":
        taclass = label_alias
    elif label_by == "SIFTClass":
        sift = label_alias
    else:
        effect = label_alias

    query = count_query.format(
        effect=effect,
        sift=sift,
        taclass=taclass,
        filtered_select_sql=filtered_select_sql,
    )

    return query


def build_mutation_query(criteria_map, table, group_by):

    query_module = """
            SELECT *
            FROM `{bq_proj_dataset}.{table}`	
            WHERE {where_clause}
        """

    count_query = """
            SELECT {group_by} AS LABEL, COUNT(*) AS CNT
            FROM ({filtered_select_sql})
            GROUP BY {group_by}
            ORDER BY CNT DESC
    """
    if not criteria_map or len(criteria_map) == 0:
        criteria_map = criteria_map or {"include": [], "exclude": []}
    filtered_select_sql = ""
    for type in ["include", "exclude"]:
        if type == "include":
            filtered_select_sql += query_module
            where_clause = build_where_clause(criteria_map[type], include=True)
        elif len(criteria_map[type]):
            filtered_select_sql += "\nEXCEPT DISTINCT ("
            filtered_select_sql += query_module
            filtered_select_sql += "\n)"
            where_clause = build_where_clause(criteria_map[type], include=False)
        else:
            where_clause = ""

        if where_clause:
            filtered_select_sql = filtered_select_sql.format(
                bq_proj_dataset=bq_proj_dataset, table=table, where_clause=where_clause
            )
    query = count_query.format(
        group_by=group_by, filtered_select_sql=filtered_select_sql
    )
    return query


def build_query_w_exclusion(
    criteria_map,
    table,
    column_filters=None,
    do_counts=False,
    distinc_col=None,
    ord_column_list=None,
    desc_ord=False,
    start=0,
    length=None,
):
    filtered_select_sql = ""
    query_module = """
                SELECT {select_clause}
                FROM `{bq_proj_dataset}.{table}`	
                WHERE {where_clause}
            """

    if column_filters:
        select_clause = ", ".join(column_filters)
    elif distinc_col:
        select_clause = distinc_col
    else:
        select_clause = "*"
    if not criteria_map or len(criteria_map) == 0:
        criteria_map = criteria_map or {"include": [], "exclude": []}

    # select_clause = distinc_col if distinc_col else '*'
    for type in ["include", "exclude"]:
        if type == "include":
            filtered_select_sql += query_module
            where_clause = build_where_clause(criteria_map[type], include=True)
        elif len(criteria_map[type]):
            filtered_select_sql += "\nEXCEPT DISTINCT ("
            filtered_select_sql += query_module
            filtered_select_sql += "\n)"
            where_clause = build_where_clause(criteria_map[type], include=False)
        else:
            where_clause = "TRUE"

        filtered_select_sql = filtered_select_sql.format(
            select_clause=select_clause,
            bq_proj_dataset=bq_proj_dataset,
            table=table,
            where_clause=where_clause,
        )
    if do_counts:
        filtered_select_sql = "SELECT COUNT(*) as CNT FROM (\n" + filtered_select_sql
        filtered_select_sql += "\n)"
    else:
        if ord_column_list:
            ord_columns = " {ord_dir}, ".join(ord_column_list)
            ord_dir = "DESC" if desc_ord else ""

            filtered_select_sql += " ORDER BY {ord_columns} {ord_dir}".format(
                ord_columns=ord_columns.format(ord_dir=ord_dir), ord_dir=ord_dir
            )
        if length:
            filtered_select_sql += " LIMIT {limit_cnt} OFFSET {skip_rows}".format(
                limit_cnt=length, skip_rows=start
            )

    return filtered_select_sql


def build_codon_dist_query(column, table):
    query_temp = """
        (
            SELECT {column} AS LABEL, COUNT(*) AS CNT
            FROM `{bq_proj_dataset}.{table}`
            WHERE {column} > 0
            AND Type_ID IN (6, 7, 8, 9, 10, 11, 12) 
            GROUP BY {column}
        )
        UNION DISTINCT
        (
            SELECT Codon_number AS LABEL, 0 AS CNT 
            FROM `{bq_proj_dataset}.p53_sequence`
            WHERE Codon_number > 0
            AND Codon_number NOT IN
            (
                SELECT {column}
                FROM `{bq_proj_dataset}.{table}`
                WHERE {column} > 0
                AND Type_ID IN (6, 7, 8, 9, 10, 11, 12)
                GROUP BY {column}
            )
        )
        ORDER BY LABEL
    """
    query = query_temp.format(
        bq_proj_dataset=bq_proj_dataset, column=column, table=table
    )
    return query


def build_mutation_dist_sum_query(criteria_map, table, group_by, sum_col):

    query_module = """
            SELECT *
            FROM `{bq_proj_dataset}.{table}`	
            WHERE {where_clause}
        """

    sum_query = """
            SELECT {group_by} AS LABEL, SUM({sum_col}) AS CNT
            FROM ({filtered_select_sql})
            GROUP BY {group_by}
            ORDER BY CNT DESC
    """
    filtered_select_sql = ""
    if not criteria_map or len(criteria_map) == 0:
        criteria_map = criteria_map or {"include": [], "exclude": []}
    for type in ["include", "exclude"]:
        if type == "include":
            filtered_select_sql += query_module
            where_clause = build_where_clause(criteria_map[type], include=True)
        elif len(criteria_map[type]):
            filtered_select_sql += "\nEXCEPT DISTINCT ("
            filtered_select_sql += query_module
            filtered_select_sql += "\n)"
            where_clause = build_where_clause(criteria_map[type], include=False)
        else:
            where_clause = ""

        if where_clause:
            filtered_select_sql = filtered_select_sql.format(
                bq_proj_dataset=bq_proj_dataset, table=table, where_clause=where_clause
            )
    query = sum_query.format(
        group_by=group_by, sum_col=sum_col, filtered_select_sql=filtered_select_sql
    )
    return query


def build_mutation_view_join_query(
    mut_id, join_table, column_filters, join_column, ord_column
):
    query_temp = """
        #standardSQL
        SELECT {columns}
        FROM `{bq_proj_dataset}.{join_table}` tbl
        JOIN `{bq_proj_dataset}.MutationView` mv
        ON mv.{join_column} = tbl.{join_column}
        WHERE mv.MUT_ID = {mut_id}
        GROUP BY {columns}
        ORDER BY tbl.{ord_column}
        """
    columns = ", ".join("tbl.{0}".format(col) for col in column_filters)
    query = query_temp.format(
        bq_proj_dataset=bq_proj_dataset,
        mut_id=mut_id,
        join_table=join_table,
        columns=columns,
        join_column=join_column,
        ord_column=ord_column,
    )

    return query


def validate_vals(vals):
    for val in vals:
        if type(val) == str and re.search(
            r"\"|(\'|\")\s?\)|SELECT|FROM|--", val, re.IGNORECASE
        ):
            raise BadRequest("Invalid user input found")


def build_where_clause(criteria, include=True):
    where_clause = "TRUE" if include else "FALSE"
    or_groups = {}
    log_op = "AND" if include else "OR"
    for criterion in criteria:
        column_name = criterion.get("column_name")
        vals = criterion.get("vals")
        validate_vals(vals)
        wrap_with = criterion.get("wrap_with", "")

        or_group = criterion.get("or_group")
        if or_group and not or_groups.get(or_group, False):
            or_groups[or_group] = []

        # numeric range
        between_op = criterion.get("between_op")
        if between_op:
            start_val = vals[0]
            end_val = vals[1]
            where_clause += "\n{log_op} ( {column_name} >= {start_val} AND {column_name} <= {end_val} )".format(
                column_name=column_name,
                start_val=start_val,
                end_val=end_val,
                log_op=log_op,
            )
        else:
            op = "IN" if len(vals) > 1 else "="
            vals_str = ", ".join(
                "{wrap_with}{val}{wrap_with}".format(val=val, wrap_with=wrap_with)
                for val in vals
            )
            if or_group:
                or_groups[or_group].append(
                    "{column_name} {op} ({vals_str})".format(
                        column_name=column_name, op=op, vals_str=vals_str
                    )
                )
            else:
                where_clause += "\n{log_op} {column_name} {op} ({vals_str})".format(
                    column_name=column_name, op=op, log_op=log_op, vals_str=vals_str
                )

    for group in or_groups:
        where_clause += (
            "\n{log_op} (".format(log_op=log_op) + (" OR ".join(or_groups[group])) + ")"
        )
    return where_clause


def build_simple_query(
    criteria,
    table,
    column_filters,
    do_counts=False,
    distinct_col=None,
    ord_column=None,
    desc_ord=False,
    start=0,
    length=None,
):
    where_clause = build_where_clause(criteria)
    columns = ", ".join(column_filters)
    order_by_clause = ""
    limit_clause = ""
    if do_counts:
        select_clause = "COUNT(DISTINCT {distinct_col}) as CNT".format(
            distinct_col=distinct_col
        )
        group_by = ""
    else:
        select_clause = columns
        if select_clause == "*":
            group_by = ""
        else:
            group_by = "GROUP BY {columns}".format(columns=columns)
        if ord_column:
            ord_dir = "DESC" if desc_ord else ""
            order_by_clause = "ORDER BY {ord_column} {ord_dir}".format(
                ord_column=ord_column, ord_dir=ord_dir
            )
            if distinct_col:
                order_by_clause += ", {distinct_col} {ord_dir}\n".format(
                    distinct_col=distinct_col, ord_dir=ord_dir
                )
        if length:
            limit_clause = "LIMIT {limit_cnt} OFFSET {skip_rows}".format(
                limit_cnt=length, skip_rows=start
            )

    query_str = """
            #standardSQL
            SELECT {select_clause}
            FROM `{bq_proj_dataset}.{table}`
            WHERE {where_clause}
            {group_by}
            {order_by_clause}
            {limit_clause}
        """.format(
        bq_proj_dataset=bq_proj_dataset,
        select_clause=select_clause,
        where_clause=where_clause,
        table=table,
        group_by=group_by,
        order_by_clause=order_by_clause,
        limit_clause=limit_clause,
    )

    return query_str


def build_mutation_prevalence():
    query_temp = """
            SELECT Topography, Sample_analyzed, Sample_mutated
            FROM `{bq_proj_dataset}.PrevalenceStat`	
            WHERE Sample_analyzed > 500 AND Topography != ''
            ORDER BY ((Sample_mutated*100) / Sample_analyzed) DESC
        """
    query = query_temp.format(bq_proj_dataset=bq_proj_dataset)
    return query
