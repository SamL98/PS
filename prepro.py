import pandas as pd

df = pd.read_csv('final_output.csv')
def strip_quotes(s):
    s = str(s)

    if s[0] == '"':
        return s[1:-1]
    elif s[0] == ' ':
        return s[2:-1]
    return s

for col in df.columns:
    df[col] = df[col].apply(strip_quotes)
num_cols = ['code', 'index', 'rand_index', 'time_spent']
df[num_cols] = df[num_cols].apply(pd.to_numeric)
df = df[df.candidate != '']
df = df[df.candidate != 'nan']

data = {
    'subjid': [],
    'condition': [],
    'totalposreal': [],
    'totalnegreal': [],
    'totalneureal': [],
    'totalposlure': [],
    'totalneglure': [],
    'totalneulure': [],
    'avgtimeposreal': [],
    'avgtimenegreal': [],
    'avgtimeneureal': [],
    'avgtimeallreal': [],
    'avgtimeposlure': [],
    'avgtimeneglure': [],
    'avgtimeneulure': [],
    'avgtimealllure': [],
    'avgtimeall': []}
#outdf['subjid'] = outdf['subjid'].astype(str)
#int_cols = outdf.columns[1:6]
#for colname in int_cols:
#	outdf[colname] = outdf[colname].astype(int)

def agg_stat(rows, code, lure, count):
    #print(len(rows), code, lure)
    #print(rows.code)
    #print(rows.lure)

    if code >= 0:
        rows = rows[rows.code == code]
    #print('2', len(rows))
    #print(rows.lure, lure)
    #print(rows.lure == lure)
    if not lure is None:
        rows = rows[rows.lure == str(lure)]
    #print('3', len(rows))

    if count:
        return len(rows)

    #print(len(rows))
    #exit()
    if len(rows) == 0:
        return 'na'
    return rows['time_spent'].mean()/1000.0		

sc_pairs = set(list(zip(df.subj_id, df.condition)))
for subj, cond in sc_pairs:
    visits = df[(df.subj_id == subj) & (df.condition == cond)]
    data['subjid'].append(subj)
    data['condition'].append(cond)
    data['totalposreal'].append(agg_stat(visits, 1, False, True))
    data['totalnegreal'].append(agg_stat(visits, 2, False, True))
    data['totalneureal'].append(agg_stat(visits, 0, False, True))
    data['totalposlure'].append(agg_stat(visits, 1, True, True))
    data['totalneglure'].append(agg_stat(visits, 2, True, True))
    data['totalneulure'].append(agg_stat(visits, 0, True, True))
    data['avgtimeposreal'].append(agg_stat(visits, 1, False, False))
    data['avgtimenegreal'].append(agg_stat(visits, 2, False, False))
    data['avgtimeneureal'].append(agg_stat(visits, 0, False, False))
    data['avgtimeallreal'].append(agg_stat(visits, -1, False, False))
    data['avgtimeposlure'].append(agg_stat(visits, 0, True, False))
    data['avgtimeneglure'].append(agg_stat(visits, 1, True, False))
    data['avgtimeneulure'].append(agg_stat(visits, 2, True, False))
    data['avgtimealllure'].append(agg_stat(visits, -1, True, False))
    data['avgtimeall'].append(agg_stat(visits, -1, None, False))

outdf = pd.DataFrame(data=data)
outdf.to_csv('aggregate_final.csv', sep=',')
