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

  INSERT INTO "DashboardFolder" (
    id, name, "parentFolderId", "workspaceId", "createdAt", "updatedAt"
  )
  VALUES
    ('atc-folder-mypets', 'MyPets', NULL, target_workspace_id, NOW(), NOW()),
    ('atc-folder-facelove', 'FaceLove', NULL, target_workspace_id, NOW(), NOW()),
    ('atc-folder-novidades', 'Novidades.Store', NULL, target_workspace_id, NOW(), NOW()),
    ('atc-folder-atlashub', 'AtlasHub', NULL, target_workspace_id, NOW(), NOW()),
    ('atc-folder-treinomilitar', 'TreinoMilitar', NULL, target_workspace_id, NOW(), NOW())
  ON CONFLICT (id) DO UPDATE
    SET name = EXCLUDED.name,
        "workspaceId" = EXCLUDED."workspaceId",
        "updatedAt" = NOW();

  IF NOT EXISTS (
    SELECT 1 FROM "Typebot"
     WHERE "workspaceId" = target_workspace_id
       AND (id = 'atc-bot-mypets' OR "publicId" = 'mypets')
  ) THEN
    INSERT INTO "Typebot" (
      id, version, name, "folderId", groups, events, variables, edges,
      theme, settings, "publicId", "workspaceId", "createdAt", "updatedAt"
    )
    VALUES (
      'atc-bot-mypets', '6.1', 'Atendimento Principal',
      'atc-folder-mypets',
      '[]'::jsonb,
      '[{"type":"start","graphCoordinates":{"x":0,"y":0},"id":"atc-start-mypets"}]'::jsonb,
      '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
      '{"general":{"isBrandingEnabled":false}}'::jsonb,
      'mypets', target_workspace_id, NOW(), NOW()
    );
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM "Typebot"
     WHERE "workspaceId" = target_workspace_id
       AND (id = 'atc-bot-facelove' OR "publicId" = 'facelove')
  ) THEN
    INSERT INTO "Typebot" (
      id, version, name, "folderId", groups, events, variables, edges,
      theme, settings, "publicId", "workspaceId", "createdAt", "updatedAt"
    )
    VALUES (
      'atc-bot-facelove', '6.1', 'Atendimento Principal',
      'atc-folder-facelove',
      '[]'::jsonb,
      '[{"type":"start","graphCoordinates":{"x":0,"y":0},"id":"atc-start-facelove"}]'::jsonb,
      '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
      '{"general":{"isBrandingEnabled":false}}'::jsonb,
      'facelove', target_workspace_id, NOW(), NOW()
    );
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM "Typebot"
     WHERE "workspaceId" = target_workspace_id
       AND (id = 'atc-bot-novidades' OR "publicId" = 'novidades')
  ) THEN
    INSERT INTO "Typebot" (
      id, version, name, "folderId", groups, events, variables, edges,
      theme, settings, "publicId", "workspaceId", "createdAt", "updatedAt"
    )
    VALUES (
      'atc-bot-novidades', '6.1', 'Atendimento Principal',
      'atc-folder-novidades',
      '[]'::jsonb,
      '[{"type":"start","graphCoordinates":{"x":0,"y":0},"id":"atc-start-novidades"}]'::jsonb,
      '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
      '{"general":{"isBrandingEnabled":false}}'::jsonb,
      'novidades', target_workspace_id, NOW(), NOW()
    );
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM "Typebot"
     WHERE "workspaceId" = target_workspace_id
       AND (id = 'atc-bot-atlashub' OR "publicId" = 'atlashub')
  ) THEN
    INSERT INTO "Typebot" (
      id, version, name, "folderId", groups, events, variables, edges,
      theme, settings, "publicId", "workspaceId", "createdAt", "updatedAt"
    )
    VALUES (
      'atc-bot-atlashub', '6.1', 'Atendimento Principal',
      'atc-folder-atlashub',
      '[]'::jsonb,
      '[{"type":"start","graphCoordinates":{"x":0,"y":0},"id":"atc-start-atlashub"}]'::jsonb,
      '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
      '{"general":{"isBrandingEnabled":false}}'::jsonb,
      'atlashub', target_workspace_id, NOW(), NOW()
    );
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM "Typebot"
     WHERE "workspaceId" = target_workspace_id
       AND (id = 'atc-bot-treinomilitar' OR "publicId" = 'treinomilitar')
  ) THEN
    INSERT INTO "Typebot" (
      id, version, name, "folderId", groups, events, variables, edges,
      theme, settings, "publicId", "workspaceId", "createdAt", "updatedAt"
    )
    VALUES (
      'atc-bot-treinomilitar', '6.1', 'Atendimento & Vendas',
      'atc-folder-treinomilitar',
      '[]'::jsonb,
      '[{"type":"start","graphCoordinates":{"x":0,"y":0},"id":"atc-start-treinomilitar"}]'::jsonb,
      '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
      '{"general":{"isBrandingEnabled":false}}'::jsonb,
      'treinomilitar', target_workspace_id, NOW(), NOW()
    );
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM "Typebot"
     WHERE "workspaceId" = target_workspace_id
       AND (id = 'atc-bot-treinomilitar-coach' OR "publicId" = 'treinomilitar-coach')
  ) THEN
    INSERT INTO "Typebot" (
      id, version, name, "folderId", groups, events, variables, edges,
      theme, settings, "publicId", "workspaceId", "createdAt", "updatedAt"
    )
    VALUES (
      'atc-bot-treinomilitar-coach', '6.1', 'Personal Trainer IA',
      'atc-folder-treinomilitar',
      '[]'::jsonb,
      '[{"type":"start","graphCoordinates":{"x":0,"y":0},"id":"atc-start-treinomilitar-coach"}]'::jsonb,
      '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
      '{"general":{"isBrandingEnabled":false}}'::jsonb,
      'treinomilitar-coach', target_workspace_id, NOW(), NOW()
    );
  END IF;

  RAISE NOTICE 'Workspace % preparado como Atendimento.Center, branding OFF, 5 operações e 6 bots criados.', target_workspace_id;
END
$$;
