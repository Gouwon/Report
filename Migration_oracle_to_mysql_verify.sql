import migration_oracle_to_mysql_util_0001 as mu

target_to_source ={"Job" : "JOBS", "Department" : "DEPARTMENTS", "Employee" : "EMPLOYEES", "JobHistory": "JOB_HISTORY"}

for target_to_source_name in target_to_source:
    mysql_cnt = mu.get_count("mysql", target_to_source_name)
    sampling = round(mysql_cnt / 3)
    mysql_smpls = mu.get_sample("mysql", target_to_source_name, sampling)
    oracle_cnt = mu.get_count("oracle", target_to_source[target_to_source_name])

    if oracle_cnt != mysql_cnt:
        print("NOT VALIED!!!! \nmysql_cnt = ", mysql_cnt, "\noracle_cnt = ", oracle_cnt)
        break
    else:
        print("Count is OK!(mysql_cnt : {} / oracle_cnt : {})\n".format(mysql_cnt, oracle_cnt))
        for i, j in enumerate(mysql_smpls):
            oracle_smpls = mu.get_sample_to_verify(target_to_source[target_to_source_name], j[0], j[1] )
            print("mysql_smpls >>>>>>>>>>>>>>>>>>>>",j)
            print("<<<<<<<<<<<<<<<<<<< oracle_smpls",oracle_smpls[0])
            if j[0:] == oracle_smpls[0][0:]:
                print("\nSQL {:d} of {} : OOOOOKKKKK\n".format(i + 1, target_to_source_name))
                print("==========================================================================================================================================")
            else:
                print("\nSQL {:d} of {} : NOT MATCHED!!!!!")
                exit()
        
