{ ... }:
{
  perSystem = { ... }: {
    pre-commit.settings.hooks = {
      end-of-file-fixer.enable = true;
      check-merge-conflicts.enable = true;
    };
  };
}
