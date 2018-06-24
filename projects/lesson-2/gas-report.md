# Gas Records for calculating runway

**Without optimization**

| #employee | tx cost | execution cost |
|-----------|---------|----------------|
| 1         | 22974   | 1702           |
| 2         | 23755   | 2483           |
| 3         | 24536   | 3264           |
| 4         | 25317   | 4045           |
| 5         | 26098   | 4826           |
| 6         | 26879   | 5607           |
| 7         | 27660   | 6388           |
| 8         | 28441   | 7169           |
| 9         | 29222   | 7950           |
| 10        | 30003   | 8731           |

Gas usage increases because the more employees, the more operations are needed for the loop to calculate the sum of salaries.

An optimization would be using a storage variable `totalSalary` and update it whenever we add / remove / update employees, thus the cost of calculating the total salary is amortized to each individual state modifying operation.

After this optimization, the gas usage keeps consistent at a very low level.

**After optimization**

| #employee | tx cost | execution cost |
|-----------|---------|----------------|
| 1         | 22132   | 860           |
| 2         | 22132   | 860           |
| 3         | 22132   | 860           |
| 4         | 22132   | 860           |
| 5         | 22132   | 860           |
| 6         | 22132   | 860           |
| 7         | 22132   | 860           |
| 8         | 22132   | 860           |
| 9         | 22132   | 860           |
| 10        | 22132   | 860           |
