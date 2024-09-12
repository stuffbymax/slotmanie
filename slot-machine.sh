#!/bin/bash

# File to store the high score
SCORE_FILE="high_score.txt"

# Function to simulate sound effects
sound_effect() {
    case $1 in
        spin)
        clear
            echo "🎰 Spinning the reels... 🌀 Let's see how quickly the casino can take your money!"
            ;;
        win)
        clear
            echo "✨ Ding ding ding! A rare win! The casino must have let its guard down! ✨"
            ;;
        lose)
        clear
            echo "💸 Another spin, another donation to the casino's vault! 💸"
            ;;
        jackpot)
        clear
            echo "🎉 JACKPOT!!! Enjoy it while it lasts, because it won’t happen again! 🎉"
            ;;
        bonus)
        clear
            echo "🌟 BONUS ROUND! The casino's algorithm probably glitched! 🌟"
            ;;
    esac
}

# Function to spin the reels
spin_reels() {
    symbols=("🍒" "🍋" "🔔" "🍀" "💎" "7️⃣" "💰" "⭐")
    reels=()
    for i in {1..3}; do
        reel=${symbols[$RANDOM % ${#symbols[@]}]}
        reels+=("$reel")
    done
    echo "${reels[@]}"
}

# Function to check winnings
check_winnings() {
    local payout=0
    local reels=("$@")

    if [[ ${reels[0]} == ${reels[1]} && ${reels[1]} == ${reels[2]} ]]; then
        if [[ ${reels[0]} == "💰" ]]; then
        clear
            payout=$((bet * 10))
            echo "The casino's rigged system must be malfunctioning! You hit the 💰💰💰 jackpot! You won $payout coins!"
        else
        clear
            payout=$((bet * 5))
            echo "All three symbols match! The casino must be regretting this one. You won $payout coins!"
        fi
    elif [[ ${reels[0]} == ${reels[1]} || ${reels[1]} == ${reels[2]} || ${reels[0]} == ${reels[2]} ]]; then
        if [[ " ${reels[*]} " =~ " 💰 " ]]; then
            clear
            payout=$((bet * 3))
            echo "You matched two symbols, and one is 💰! The casino will let you win this time, but don't get used to it. You won $payout coins!"
        else
        clear
            payout=$((bet * 2))
            echo "Two symbols match! A small win to keep you playing. You won $payout coins!"
        fi
    else
    clear
        echo "No match, as expected. The casino thanks you for your generous contribution of $bet coins!"
    fi

    if [[ " ${reels[*]} " == " ⭐ ⭐ ⭐ " ]]; then
    clear
        trigger_bonus_round
    fi
clear
    echo "Balance: $((balance + payout - bet)) coins"
    return $payout
}

# Function to trigger a bonus round
trigger_bonus_round() {
clear
    echo "Welcome to the BONUS ROUND! The casino didn't see this coming. Enjoy it while you can!"

    bonus_spin=$(spin_reels)
    echo "$bonus_spin"
    sound_effect win
    echo "You won an extra $((bet * 5)) coins in the bonus round! The casino will be deducting this from your future wins."
    balance=$((balance + (bet * 5)))
}

# Function to update and display high scores
update_high_score() {
    if (( balance > high_score )); then
    clear
        high_score=$balance
        echo "🏆 New High Score! You reached $high_score coins! The casino is not pleased."
        echo "$high_score" > "$SCORE_FILE"
    fi
}

# Function to load the high score from file
load_high_score() {
	clear
    if [[ -f "$SCORE_FILE" ]]; then
        high_score=$(cat "$SCORE_FILE")
    else
        high_score=0
    fi
}

# Main game loop
play_slot_machine() {
    load_high_score
    balance=100  # Starting balance
    progressive_jackpot=500  # Progressive jackpot starting amount
clear
    echo "Welcome to the Casino! You start with $balance coins. The house always wins, but let's see how long you can last!"

    while true; do
        echo "Your current balance is $balance coins."
        read -p "Place your bet (minimum 1 coin, max $balance): " bet
        if (( bet > balance || bet <= 0 )); then
            echo "Invalid bet. You can't bet more than your balance or less than 1 coin. Even the casino has rules, but they're all rigged in its favor."
            continue
        fia

        spin_result=$(spin_reels)
        echo "$spin_result"
        
        check_winnings $spin_result
        payout=$?
        balance=$((balance + payout - bet))
        progressive_jackpot=$((progressive_jackpot + bet / 10))

        update_high_score

        if (( balance <= 0 )); then
        clear
            echo "You're out of coins! The casino wins again, as usual. Better luck next time, though luck has nothing to do with it!"
            break
        fi
        clear
        echo "Current Progressive Jackpot: $progressive_jackpot coins. But don't get your hopes up, the odds are slimmer than a casino's ethics."
        read -p "Do you want to play again and give the casino more of your money? (y/n): " play_again
        if [[ $play_again != "y" ]]; then
            echo "Smart move! Walk away with your remaining $balance coins while you still can. The casino will be waiting for your return."
            break
        fi
    done
clear
    echo "Your final balance was $balance coins, and your highest score was $high_score coins."
    echo "Thank you for playing! The casino will now use your losses to fund its next gaudy expansion. Come back soon!"
}

# Run the game
play_slot_machine
