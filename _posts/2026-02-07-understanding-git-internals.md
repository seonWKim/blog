---
layout: post
title: "Understanding Git Internals - How Git Stores Your Code"
date: 2026-02-07
categories: [ programming ]
tags: [ git, internals, version-control ]
---

I've been using Git daily for years, but I never stopped to think about what actually happens when I run `git commit`. Turns out, Git is essentially a content-addressable filesystem with a VCS user interface built on top. Here's what I learned by poking around the `.git` directory.

## Git is a Key-Value Store

At its core, Git is a simple key-value data store. You give it content, it gives you back a SHA-1 hash that you can use to retrieve that content later.

```bash
$ echo "hello world" | git hash-object --stdin -w
95d09f2b10159347eece71399a7e2e907ea3df4f
```

This hash is computed from the content itself. The same content always produces the same hash—this is what makes Git a **content-addressable** store.

## The Three Object Types

Git stores everything using three fundamental object types:

### 1. Blob

A blob stores file contents. Nothing else—no filename, no permissions. Just raw content.

```
blob <size>\0<content>
```

Two files with identical content share the same blob, regardless of their filenames. This is how Git stays space-efficient.

### 2. Tree

A tree maps filenames to blobs (and other trees for subdirectories). Think of it as a directory listing.

```
100644 blob a1b2c3... README.md
100644 blob d4e5f6... main.py
040000 tree f7g8h9... src/
```

### 3. Commit

A commit points to a tree (the project snapshot) and contains metadata:

```
tree 9a8b7c...
parent 1d2e3f...
author Seonwoo Kim <email> 1707300000 +0900
committer Seonwoo Kim <email> 1707300000 +0900

Add feature X
```

The parent field is what forms the commit history chain.

## What Happens During `git commit`

When you run `git commit`, Git performs these steps:

1. **Creates blobs** for each staged file's content
2. **Creates tree objects** that represent the directory structure, pointing to the blobs
3. **Creates a commit object** that points to the root tree, the parent commit, and stores the metadata

```
commit → tree (root)
           ├── blob (README.md)
           ├── blob (main.py)
           └── tree (src/)
                 └── blob (app.py)
```

## Branches Are Just Pointers

Here's the part that surprised me most. A branch in Git is just a 41-byte file containing a commit hash.

```bash
$ cat .git/refs/heads/main
e5a9bfd1234567890abcdef1234567890abcdef
```

When you create a new branch, Git creates a new file in `.git/refs/heads/`. When you commit, it updates that file to point to the new commit. That's it.

`HEAD` is another pointer—it points to the current branch:

```bash
$ cat .git/HEAD
ref: refs/heads/main
```

This is why branch creation in Git is nearly instantaneous, unlike older VCS systems that would copy the entire codebase.

## The Index (Staging Area)

The staging area is stored in `.git/index` as a binary file. It holds a sorted list of file paths, each with:

- File permissions and metadata
- The SHA-1 of the blob for that file
- Stage number (used during merge conflicts)

When you run `git add`, Git creates the blob object and updates the index. When you run `git commit`, Git builds trees from the index.

## Packfiles

Storing every version of every file as a separate object would waste space quickly. Git periodically runs garbage collection (`git gc`) which:

1. Finds objects that are similar
2. Stores the most recent version in full
3. Stores older versions as **deltas** (differences from the newer version)
4. Packs everything into a `.pack` file with an `.idx` index

Note that Git stores deltas against the **newer** version, not the older one. This is because you access recent versions more often, so they should be fastest to reconstruct.

## Why This Matters

Understanding Git internals helps you:

- **Debug confidently.** When `git reflog` shows you a lost commit, you know it's still an object in the database—you just need to find its hash.
- **Understand performance.** Large binary files are expensive because Git can't delta-compress them well.
- **Use advanced features.** Commands like `git replace`, `git filter-branch`, and `git worktree` make more sense when you understand the object model.

The next time something goes wrong with Git, remember: it's all just objects and pointers. You can inspect everything directly in `.git/`.
