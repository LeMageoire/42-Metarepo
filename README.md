# 42 School — Meta-Repository

This is a meta-repository that indexes and tracks multiple 42 School projects using Git submodules. This repository contains **no source code**—all projects are referenced as external Git submodules.

## Purpose

This repository serves as a centralized index for tracking progress across all 42 School curriculum projects. Each project is maintained in its own independent repository and linked here as a submodule, preserving separation of concerns while providing unified version tracking.

## Repository Structure

```
42-Metarepo/
├── docs/                   # Documentation and resources
├── projects/
│   ├── piscine/            # Piscine projects and exercises
│   ├── commoncore/         # Mandatory curriculum projects
│   │   ├── level0/
│   │   ├── level1/
│   │   ├── level2/
│   │   ├── level3/
│   │   ├── level4/
│   │   ├── level5/
│   │   └── level6/
│   └── specialty/          # Specialized track projects
└── scripts/                # Automation tooling
```

## Project Status

### Status Legend

| Symbol | Meaning      |
|--------|--------------|
| ✓      | Validated    |
| ⧗      | In Progress  |
| ○      | Design Phase |
| —      | Not Started  |

---

### Piscine

| Project    | Status | Notes                            |
|------------|--------|----------------------------------|
| 42-Piscine | ✓      | Complete piscine project archive |

---

### Level 0

| Project | Status | Notes                          |
|---------|--------|--------------------------------|
| libft   | ✓      | First C library implementation |

### Level 1

| Project       | Status | Notes                                        |
|---------------|--------|----------------------------------------------|
| born2beroot   | ✓      | System administration and virtualization     |
| ft_printf     | ✓      | printf function reimplementation             |
| get_next_line | ✓      | Line reading function with static variables  |

### Level 2

| Project   | Status | Notes                              |
|-----------|--------|------------------------------------|
| pipex     | ✓      | Unix pipe mechanism implementation |
| push_swap | ✓      | Sorting algorithm optimization     |
| so_long   | ✓      | 2D game with MiniLibX              |

### Level 3

| Project      | Status | Notes                                   |
|--------------|--------|-----------------------------------------|
| minishell    | ✓      | Shell implementation with bash features |
| philosophers | ✓      | Concurrency and threading               |

### Level 4

| Project          | Status | Notes                            |
|------------------|--------|----------------------------------|
| cub3d            | ✓      | Raycasting 3D engine             |
| NetPractice      | ✓      | Network configuration and TCP/IP |
| cpp_module 00-05 | ✓      | C++ fundamentals and OOP         |

### Level 5

| Project          | Status | Notes                                                  |
|------------------|--------|--------------------------------------------------------|
| webserv          | ✓      | HTTP/1.1 web server implementation                     |
| inception        | ⧗      | Docker multi-container infrastructure                  | 
| cpp_module 05-09 | ⧗      | Advanced C++ patterns and STL (cpp_09 in progress)     |

### Level 6

| Project                 | Status | Notes                          |
|-------------------------|--------|--------------------------------|
| ft_transcendance        | ✓      | Full-stack web application     |
| 42_Collaborative_resume | —      | Collaborative project resume   |

---

## Specialty Track

| Project       | Status | Notes                              |
|---------------|--------|------------------------------------|
| learn2slither | ✓      | Python programming track           |
| ft_ls         | ✓      | Unix ls command reimplementation   |

---

## Submodule Management

### Synchronization Policy

This repository tracks specific commits of each submodule. Submodule pointers are updated manually using the synchronization script after validating changes in individual project repositories.

**Key principles:**

- Submodules remain on their `main` branch
- Updates are fetched and pulled automatically
- Submodule pointer updates require manual commit
- No automatic commits to prevent unintended state changes

### Usage

#### Clone this repository with all submodules

```bash
git clone --recursive git@github.com:LeMageoire/42-Metarepo.git
```

If already cloned without `--recursive`:

```bash
git submodule update --init --recursive
```

#### Synchronize all submodules to latest main branch

```bash
./scripts/update_submodules_main.sh
```

This script will:
1. Fetch latest changes from origin for each submodule
2. Checkout the `main` branch
3. Pull latest commits
4. Skip submodules without a `main` branch
5. Report status and failures

After synchronization, review changes:

```bash
git status
```

Commit updated submodule pointers:

```bash
git add .
git commit -m "chore: update submodule pointers to latest main"
git push
```

#### Update a single submodule manually

```bash
cd projects/commoncore/level0/libft
git checkout main
git pull origin main
cd -
git add projects/commoncore/level0/libft
git commit -m "chore: update libft submodule pointer"
```

#### Add a new project as submodule

```bash
git submodule add <repository-url> projects/commoncore/<level>/<project-name>
git commit -m "feat: add <project-name> submodule"
```

## Development Workflow

1. Work on individual projects in their respective repositories
2. Push changes to project repositories
3. Run synchronization script in meta-repository
4. Review submodule pointer updates
5. Commit and push meta-repository changes

## Technical Notes

- All submodules must have a `main` branch for automated synchronization
- Submodule commits are tracked by SHA-1 hash
- Detached HEAD state in submodules is expected behavior when using `git submodule update`. This occurs because the meta-repository tracks a specific commit SHA, not a branch reference. To work on a submodule, explicitly checkout a branch inside the submodule directory.
- Use `git submodule status` to inspect current submodule states

## Repository Maintenance

### Check submodule health

```bash
git submodule status
```

### Reset submodules to tracked commits

```bash
git submodule update --recursive
```

### Remove a submodule

```bash
git submodule deinit -f projects/path/to/submodule
git rm -f projects/path/to/submodule
rm -rf .git/modules/projects/path/to/submodule
git commit -m "chore: remove submodule"
```

## Contributing

This is a personal project portfolio tracking individual progress through the 42 School curriculum. External contributions are not accepted.

If you are a 42 student looking to create a similar meta-repository structure:

1. Fork this repository
2. Remove all existing submodules
3. Add your own project repositories as submodules
4. Update the project status tables to reflect your progress

Individual project repositories may have their own contribution policies. Refer to each project's repository for details.

---

**Note:** This meta-repository is a tracking and indexing tool. All development work occurs in individual project repositories.