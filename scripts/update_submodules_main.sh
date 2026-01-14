#!/bin/bash

set -euo pipefail

# update_submodules_main.sh
# Synchronizes all submodules to their main branch without committing

readonly SCRIPT_NAME="$(basename "$0")"
readonly REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo ".")"

log_info() {
    printf "[%s] INFO: %s\n" "$SCRIPT_NAME" "$1"
}

log_warn() {
    printf "[%s] WARN: %s\n" "$SCRIPT_NAME" "$1" >&2
}

log_error() {
    printf "[%s] ERROR: %s\n" "$SCRIPT_NAME" "$1" >&2
}

update_submodule() {
    local submodule_path="$1"
    local submodule_name="$(basename "$submodule_path")"
    
    log_info "Processing submodule: $submodule_name"
    
    # Enter submodule directory
    cd "$REPO_ROOT/$submodule_path" || {
        log_error "Cannot access submodule at $submodule_path"
        return 1
    }
    
    # Fetch latest changes from origin
    log_info "  Fetching origin..."
    if ! git fetch origin --quiet 2>/dev/null; then
        log_warn "  Failed to fetch origin for $submodule_name"
        return 1
    fi
    
    # Check if main branch exists on remote
    if ! git ls-remote --heads origin main | grep -q main; then
        log_warn "  No 'main' branch found on origin for $submodule_name, skipping"
        return 0
    fi
    
    # Checkout main branch
    log_info "  Checking out main branch..."
    if ! git checkout main --quiet 2>/dev/null; then
        log_warn "  Failed to checkout main branch for $submodule_name"
        return 1
    fi
    
    # Pull latest changes
    log_info "  Pulling latest changes..."
    if ! git pull origin main --quiet 2>/dev/null; then
        log_error "  Failed to pull changes for $submodule_name"
        return 1
    fi
    
    log_info "  ✓ Successfully updated $submodule_name"
    return 0
}

main() {
    log_info "Starting submodule synchronization"
    log_info "Repository root: $REPO_ROOT"
    
    # Ensure we're in a git repository
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        log_error "Not a git repository"
        exit 1
    fi
    
    # Initialize and update submodule index
    log_info "Initializing submodules..."
    git submodule init --quiet || {
        log_error "Failed to initialize submodules"
        exit 1
    }
    
    # Get list of all submodules
    local submodules
    submodules=$(git config --file .gitmodules --get-regexp path | awk '{print $2}')
    
    if [ -z "$submodules" ]; then
        log_warn "No submodules found in repository"
        exit 0
    fi
    
    local total=0
    local success=0
    local failed=0
    local skipped=0
    
    # Iterate over each submodule
    while IFS= read -r submodule_path; do
        total=$((total + 1))
        
        if update_submodule "$submodule_path"; then
            if [ -d "$REPO_ROOT/$submodule_path/.git" ]; then
                success=$((success + 1))
            else
                skipped=$((skipped + 1))
            fi
        else
            failed=$((failed + 1))
        fi
        
        echo ""
    done <<< "$submodules"
    
    # Return to repository root
    cd "$REPO_ROOT"
    
    # Summary
    log_info "======================================"
    log_info "Synchronization complete"
    log_info "Total submodules: $total"
    log_info "Successfully updated: $success"
    log_info "Skipped: $skipped"
    log_info "Failed: $failed"
    log_info "======================================"
    
    if [ "$failed" -gt 0 ]; then
        log_warn "Some submodules failed to update"
        log_info "Run 'git status' to see which submodules have changes"
        exit 1
    fi
    
    log_info "Run 'git status' to review submodule pointer updates"
    log_info "Commit changes with: git add . && git commit -m 'chore: update submodule pointers'"
}

main "$@"
