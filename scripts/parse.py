#!/usr/bin/env python
import json
 
data=[]
for k, v in json.load(open("modules.json")).items():
  entries = []
  for x,y in v.items():
    #data.append([k, y['fullName'], y['Version'], y['hidden'], y.get("Description", ""), y.get('URL',"")])
    data.append(y['fullName'], k, y['Version'] y.get("Description", ""), y.get('URL',"")])
    #entries.append(dict(parent=k, name=y['fullName'], version=y['Version'], hidden=y['hidden'], description=y.get("Description", ""), url=y.get('URL',"")  ))
  #data[k] = entries
with open("data.json","w") as o:
  o.write(json.dumps(dict(data=data)))

