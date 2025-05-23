---

layout:     post 
title:      "Time Auction Simulator (Draft)"
slug:       "time-auction-simulator"
date:       2025-05-23 01:00:42
categories: [projects]

---

From the, "programming for programming's sake" desk: this is the README of a [smol simulator](https://github.com/kindrowboat/time-auction) we wrote after we watched S02E04 of The Devil's Plan.

# Time Auction Simulator

This is a simulator for different strategies in for The Devil's Plan season two day two (S02E04) prison challenge, Time Auction.

## Why?

[The Devil's Plan] is a Korean reality show. It is far-and-away the most cerebral reality show we have ever seen. Each game day, the contestants play in several novel complex [social games]—think: [mafia] on steroids. These games tend to have mixture of [game theory], puzzle solving, and [social engineering]. We highly recommend it! (We watch with English dubs; don't @ us 😉) 

Most of the games in The Devil's Plan would be tedious to try to simulate in software because: the rules are complex, most actions in the game cause ripple effects which would be tedious to model, and because humans are messy. However, when watching episode 4 of season 2, we were struck by the Prison Game, Time Auction, as a game where each person could reasonably have an algorithm for how they were going to play before they walked in the game room, eschew human emotions, and execute that algorithm. And indeed, several players do come up with algorithms, and the winner did just that.

This made us wonder: what is the optimal strategy? And we [nerd-sniped] ourselves into writing this little simulator to find a _potentially_ optimal strategy. 

It's presently incomplete. The basics of the simulator live in [`main.py`](./main.py), and different strategies live in [`strats`](./strats/). We'd like to add many more strategies, and then run simulations of all combinations of those strategies to arrive at a potentially optimal strategy.

[we]: https://kindrobot.ca
[The Devil's Plan]: https://en.wikipedia.org/wiki/The_Devil's_Plan
[social games]: https://en.wikipedia.org/wiki/Social_game
[mafia]: https://en.wikipedia.org/wiki/Mafia_(party_game)
[game theory]: https://en.wikipedia.org/wiki/Game_theory
[social engineering]: https://en.wikipedia.org/wiki/Social_engineering_(security)
[nerd-sniped]: https://en.wiktionary.org/wiki/nerd-snipe#English

## Rules for Time Auction

_(source: [https://namu.wiki/w/데블스 플랜: 데스룸/2일차#s-5](https://namu.wiki/w/%EB%8D%B0%EB%B8%94%EC%8A%A4%20%ED%94%8C%EB%9E%9C:%20%EB%8D%B0%EC%8A%A4%EB%A3%B8/2%EC%9D%BC%EC%B0%A8#s-5))_

1. "Time Auction" is a game where you bid using time to win a token.  
2. Each player is given **10 minutes** of auction funds. Time is recorded to the nearest 0.1 second.  
3. The game consists of a total of **19 auctions**.  
4. Each player has a personal button in front of them, which is hidden from other players.  
5. At the start of a round, all players stand ready with their buttons pressed.  
6. When the auction starts, a 5-second countdown will begin, and after 5 seconds, your holding time will begin to deduct.  
   - If you do not wish to participate in the auction, you can abandon the auction by releasing the button within the countdown time.  
   - Each player's holding time is not disclosed to anyone, including themselves, and only the time during the auction can be checked on the scoreboard. In other words, you must accurately remember the time you used and participate in the auction.  
7. Players participating in the auction can release the button to stop time when the amount of time they wish to bid has been deducted.  
   - If all remaining time is used up, the button is automatically pushed out immediately. In other words, bidding beyond the remaining time is not possible.[\[27\]](https://namu.wiki/w/%EB%8D%B0%EB%B8%94%EC%8A%A4%20%ED%94%8C%EB%9E%9C:%20%EB%8D%B0%EC%8A%A4%EB%A3%B8/2%EC%9D%BC%EC%B0%A8#fn-27)  
8. When the last remaining player releases the button, the clock on the scoreboard stops and that player is awarded the winning token.  
   1. It is not disclosed who participated in the auction, only the winning bidder of that round is disclosed.  
   2. If two or more players bid using the same time to the nearest 0.1 second, the winning token for that round is lost.  
9. After 19 auctions, the player who has won the most winning tokens wins the game and one piece (used in other parts of The Devil's Plan).  
   1. If the number of markers is tied, the player with more time on the board wins the piece.  
   2. If this is still a tie, no piece will be awarded.  
10. The player who bids the fewest winning tokens is ultimately eliminated.  
    1. If the number of markers is tied, the one with less time is eliminated.

## Simulator Prerequisites
* Python 3.8 or later

## Simulator Usage

### List of Strategies
```bash
./main.py --list
```

#### Example
```
$ ./main.py --list

Available Strategies:
  ed-15 | Exponential Decay 15%: bid high at the start and decay 15% each round
  ere   | Every Round Even: bid evenly in each round
  lr-4  | Bid all remaining time evenly in the last 4 rounds
  lr-5  | Bid all remaining time evenly in the last 5 rounds
  tot1  | team of three (1): bid evenly on every third round starting on round 1
  tot2  | team of three (2): bid evenly on every third round starting on round 2
  tot3  | team of three (3): bid evenly on every third round starting on round 3
```

### Run a Simulation
```bash
./main.py <strategy1> <strategy2> <strategy3> <strategy4> <strategy5> <strategy6>
```

#### Example
```
$ ./main.py tot1 tot2 tot3 lr-4 lr-5 ed-15
Round 1 winner: tot1 with bid 100.0s
  tot1    100.0 bid  1 wins   500.0s left
  ed-15    93.6 bid  0 wins   506.4s left
  tot2      0.0 bid  0 wins   600.0s left
  tot3      0.0 bid  0 wins   600.0s left
  lr-4      0.0 bid  0 wins   600.0s left
  lr-5      0.0 bid  0 wins   600.0s left
Round 2 winner: tot2 with bid 100.0s
  tot2    100.0 bid  1 wins   500.0s left
  ed-15    79.6 bid  0 wins   426.8s left
  tot3      0.0 bid  0 wins   600.0s left
  lr-4      0.0 bid  0 wins   600.0s left
  lr-5      0.0 bid  0 wins   600.0s left
  tot1      0.0 bid  1 wins   500.0s left
Round 3 winner: tot3 with bid 100.0s
  tot3    100.0 bid  1 wins   500.0s left
  ed-15    67.6 bid  0 wins   359.2s left
  lr-4      0.0 bid  0 wins   600.0s left
  lr-5      0.0 bid  0 wins   600.0s left
  tot1      0.0 bid  1 wins   500.0s left
  tot2      0.0 bid  1 wins   500.0s left
Round 4 winner: tot1 with bid 100.0s
  tot1    100.0 bid  2 wins   400.0s left
  ed-15    57.5 bid  0 wins   301.7s left
  lr-4      0.0 bid  0 wins   600.0s left
  lr-5      0.0 bid  0 wins   600.0s left
  tot2      0.0 bid  1 wins   500.0s left
  tot3      0.0 bid  1 wins   500.0s left
Round 5 winner: tot2 with bid 100.0s
  tot2    100.0 bid  2 wins   400.0s left
  ed-15    48.9 bid  0 wins   252.8s left
  lr-4      0.0 bid  0 wins   600.0s left
  lr-5      0.0 bid  0 wins   600.0s left
  tot3      0.0 bid  1 wins   500.0s left
  tot1      0.0 bid  2 wins   400.0s left
Round 6 winner: tot3 with bid 100.0s
  tot3    100.0 bid  2 wins   400.0s left
  ed-15    41.5 bid  0 wins   211.3s left
  lr-4      0.0 bid  0 wins   600.0s left
  lr-5      0.0 bid  0 wins   600.0s left
  tot1      0.0 bid  2 wins   400.0s left
  tot2      0.0 bid  2 wins   400.0s left
Round 7 winner: tot1 with bid 100.0s
  tot1    100.0 bid  3 wins   300.0s left
  ed-15    35.3 bid  0 wins   175.9s left
  lr-4      0.0 bid  0 wins   600.0s left
  lr-5      0.0 bid  0 wins   600.0s left
  tot2      0.0 bid  2 wins   400.0s left
  tot3      0.0 bid  2 wins   400.0s left
Round 8 winner: tot2 with bid 100.0s
  tot2    100.0 bid  3 wins   300.0s left
  ed-15    30.0 bid  0 wins   145.9s left
  lr-4      0.0 bid  0 wins   600.0s left
  lr-5      0.0 bid  0 wins   600.0s left
  tot3      0.0 bid  2 wins   400.0s left
  tot1      0.0 bid  3 wins   300.0s left
Round 9 winner: tot3 with bid 100.0s
  tot3    100.0 bid  3 wins   300.0s left
  ed-15    25.5 bid  0 wins   120.4s left
  lr-4      0.0 bid  0 wins   600.0s left
  lr-5      0.0 bid  0 wins   600.0s left
  tot1      0.0 bid  3 wins   300.0s left
  tot2      0.0 bid  3 wins   300.0s left
Round 10 winner: tot1 with bid 100.0s
  tot1    100.0 bid  4 wins   200.0s left
  ed-15    21.7 bid  0 wins    98.7s left
  lr-4      0.0 bid  0 wins   600.0s left
  lr-5      0.0 bid  0 wins   600.0s left
  tot2      0.0 bid  3 wins   300.0s left
  tot3      0.0 bid  3 wins   300.0s left
Round 11 winner: tot2 with bid 100.0s
  tot2    100.0 bid  4 wins   200.0s left
  ed-15    18.4 bid  0 wins    80.3s left
  lr-4      0.0 bid  0 wins   600.0s left
  lr-5      0.0 bid  0 wins   600.0s left
  tot3      0.0 bid  3 wins   300.0s left
  tot1      0.0 bid  4 wins   200.0s left
Round 12 winner: tot3 with bid 100.0s
  tot3    100.0 bid  4 wins   200.0s left
  ed-15    15.7 bid  0 wins    64.6s left
  lr-4      0.0 bid  0 wins   600.0s left
  lr-5      0.0 bid  0 wins   600.0s left
  tot1      0.0 bid  4 wins   200.0s left
  tot2      0.0 bid  4 wins   200.0s left
Round 13 winner: tot1 with bid 100.0s
  tot1    100.0 bid  5 wins   100.0s left
  ed-15    13.3 bid  0 wins    51.3s left
  lr-4      0.0 bid  0 wins   600.0s left
  lr-5      0.0 bid  0 wins   600.0s left
  tot2      0.0 bid  4 wins   200.0s left
  tot3      0.0 bid  4 wins   200.0s left
Round 14 winner: tot2 with bid 100.0s
  tot2    100.0 bid  5 wins   100.0s left
  ed-15    11.3 bid  0 wins    40.0s left
  lr-4      0.0 bid  0 wins   600.0s left
  lr-5      0.0 bid  0 wins   600.0s left
  tot3      0.0 bid  4 wins   200.0s left
  tot1      0.0 bid  5 wins   100.0s left
Round 15 winner: lr-5 with bid 120.0s
  lr-5    120.0 bid  1 wins   480.0s left
  tot3    100.0 bid  4 wins   100.0s left
  ed-15     9.6 bid  0 wins    30.4s left
  lr-4      0.0 bid  0 wins   600.0s left
  tot1      0.0 bid  5 wins   100.0s left
  tot2      0.0 bid  5 wins   100.0s left
Round 16 winner: lr-4 with bid 150.0s
  lr-4    150.0 bid  1 wins   450.0s left
  lr-5    120.0 bid  1 wins   360.0s left
  tot1    100.0 bid  5 wins     0.0s left
  ed-15     8.2 bid  0 wins    22.2s left
  tot2      0.0 bid  5 wins   100.0s left
  tot3      0.0 bid  4 wins   100.0s left
Round 17 winner: lr-4 with bid 150.0s
  lr-4    150.0 bid  2 wins   300.0s left
  lr-5    120.0 bid  1 wins   240.0s left
  tot2    100.0 bid  5 wins     0.0s left
  ed-15     7.0 bid  0 wins    15.3s left
  tot3      0.0 bid  4 wins   100.0s left
  tot1      0.0 bid  5 wins     0.0s left
Round 18 winner: lr-4 with bid 150.0s
  lr-4    150.0 bid  3 wins   150.0s left
  lr-5    120.0 bid  1 wins   120.0s left
  tot3    100.0 bid  4 wins     0.0s left
  ed-15     5.9 bid  0 wins     9.3s left
  tot1      0.0 bid  5 wins     0.0s left
  tot2      0.0 bid  5 wins     0.0s left
Round 19 winner: lr-4 with bid 150.0s
  lr-4    150.0 bid  4 wins     0.0s left
  lr-5    120.0 bid  1 wins     0.0s left
  ed-15     5.0 bid  0 wins     4.3s left
  tot1      0.0 bid  5 wins     0.0s left
  tot2      0.0 bid  5 wins     0.0s left
  tot3      0.0 bid  4 wins     0.0s left

RESULTS
  tot1    5 wins    0.0s left
  tot2    5 wins    0.0s left
  tot3    4 wins    0.0s left
  lr-4    4 wins    0.0s left
  lr-5    1 wins    0.0s left
  ed-15   0 wins    4.3s left
```

## Example strategy file:

You can add a new strategy by make a new file in `strats`. You can use the following example to get you started:

`strats/ere.py`

```python
import os
from main import RuleParameters

class Strategy:
    def __init__(self, rule_parameters: RuleParameters):
        self.name = os.path.splitext(os.path.basename(__file__))[0]
        self.description = "Every Round Evenly: bid evenly in each round"

        self.bid_per_round = rule_parameters.total_time / rule_parameters.num_rounds

    def bid(self, round_number: int, history: list, time_left: float) -> float:
        return self.bid_per_round
```