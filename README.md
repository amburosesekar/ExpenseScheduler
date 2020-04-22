# ExpenseScheduler
Expense Scheduler fully Written in Julia and Verified with Ubuntu Cloud
## Working Procedure
1. JuMP Constraint based Optimization 
2. constraint 1--> sum(schedulingAmount)= Total Amount
3. Constraint 2--> Each day Spending Amount for each type= 100%
4. Objective function
           Min, (sum(w*xd)-Amount)
           where w--> percentage of each type
                 xd--->perday spent Amount
5. display in Graph
6. Link with WebIO
### (Video Link)[https://www.facebook.com/ResearchersCodeMadeSimple/videos/1018199258577754/]
#### (Live Demo)[http://159.65.147.167/]
It's only for Temporary use. 

##### Applications
1. same code use for Desktop App using Blink(Windows/Linux/MacOS)
2. Ineractive app using Intranet like Jubyter
3. Hybrid App using Cloud(Dekstop/NotePad/MobilePhone)
4. Data Sceince/Numerical Computing App
5. used for Educational/Industrial
###### Limitation
1. Initial Latency of Web page load is high
2. Initial Compilation time also High

