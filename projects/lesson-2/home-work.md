1. Add ten employees:

Round 1:
transaction cost 22369 gas
execution 1097 gas

Round 2:
transaction cost 22369 gas
execution 1097 gas

Round 3:
transaction cost 22369 gas
execution 1097 gas

Round 4:
transaction cost 22369 gas
execution 1097 gas

Round 5:
transaction cost 22369 gas
execution 1097 gas

Round 6:
transaction cost 22369 gas
execution 1097 gas

Round 7:
transaction cost 22369 gas
execution 1097 gas

Round 8:
transaction cost 22369 gas
execution 1097 gas

Round 9:
transaction cost 22369 gas
execution 1097 gas

Round 10:
transaction cost 22369 gas
execution 1097 gas

This is the 10 observation of gases consumed after adding employees. I ran the code on https://remix.ethereum.org/#optimize=false&version=soljson-v0.4.24+commit.e67f0147.js. Previously I consider the transaction is related to the number of operation in the transaction. In this case, as number of operations in the for loop in findEmployee() is different, there should be difference in the gases. However, this is not the case.

2. The optimization of calculateRunway()
Previously calculateRunway() require O(n) time, however, if i add a member variable named totalSalary and edit it when adding or updating the employees, we make calculateRunway() executed in O(1)