# getting-and-cleaning-data-project

I took total of 4 steps to tide the data.

1. Data prep (download, unzip, read txt)
load library
download and store zip file
read texts

2. Change colnames and merge all data, and select!
rename colnames
merge all data
select only subject id, activity id, mean, std

3. Match activity & rename
match activity id to activity & rename activity.id in select_df
change abbreviated names to full names

4. Group and calculate average
group by suject.id and activity & average them
