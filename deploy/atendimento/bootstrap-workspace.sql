DO $$
DECLARE
  target_workspace_id text;
BEGIN
  SELECT id
    INTO target_workspace_id
    FROM "Workspace"
   WHERE plan = 'UNLIMITED'
   ORDER BY "createdAt" ASC
   LIMIT 1;

  IF target_workspace_id IS NULL THEN
    RAISE EXCEPTION 'Nenhum workspace UNLIMITED encontrado.';
  END IF;

  UPDATE "Workspace"
     SET name = 'Atendimento.Center',
         "updatedAt" = NOW()
   WHERE id = target_workspace_id;

  UPDATE "Typebot"
     SET settings = jsonb_set(
       COALESCE(settings::jsonb, '{}'::jsonb),
       '{general}',
       COALESCE(settings::jsonb->'general', '{}'::jsonb)
         || '{"isBrandingEnabled": false}'::jsonb,
       true
     ),
     "updatedAt" = NOW()
   WHERE "workspaceId" = target_workspace_id;

  UPDATE "PublicTypebot" published
     SET settings = jsonb_set(
       COALESCE(published.settings::jsonb, '{}'::jsonb),
       '{general}',
       COALESCE(published.settings::jsonb->'general', '{}'::jsonb)
         || '{"isBrandingEnabled": false}'::jsonb,
       true
     ),
     "updatedAt" = NOW()
    FROM "Typebot" typebot
   WHERE published."typebotId" = typebot.id
     AND typebot."workspaceId" = target_workspace_id;

  RAISE NOTICE 'Workspace % preparado como Atendimento.Center, branding OFF.', target_workspace_id;
END
$$;
